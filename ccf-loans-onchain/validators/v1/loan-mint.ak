use aiken/collection/dict
use aiken/collection/list.{filter, find, has, head}
use cardano/address.{Script}
use cardano/assets.{PolicyId, lovelace_of, policies}
use cardano/transaction.{InlineDatum, Input, Output, Transaction}
use ccfl/types.{
  ABurn, AMint, CollateralDatum, LoanDatum, LoanMintAction, MerkelConfigDatum,
  OracleDatum,
}

//                    //
// Separate Loan Mint //
//                    //

// Mints 2 tokens 
// sends one to loan vault with datum
// sends one to collateral vault with datum

validator loanMint(op: PolicyId, cp: PolicyId) {
  mint(r: LoanMintAction, policyId: PolicyId, tx: Transaction) {
    let Transaction { mint, outputs, reference_inputs, .. } = tx

    expect [Pair(_tName, tAmt)] =
      mint
        |> assets.tokens(policyId)
        |> dict.to_pairs()

    when r is {
      AMint { amount, rewards, term, timestamp } -> {
        // checks for Oracle ref in
        expect Some(oracleOut) =
          find(outputs, fn(output) { has(policies(output.value), op) })
        expect [Pair(oracleTn, 1)] =
          oracleOut.value
            |> assets.tokens(op)
            |> dict.to_pairs()
        // checks oracle datum
        expect InlineDatum(datum) = oracleOut.datum
        expect rDatum: OracleDatum = datum
        // pulls exchange rate
        let exchangeRate = rDatum.exchange
        // checks for config input
        expect Some(configIn) =
          head(
            filter(
              reference_inputs,
              fn(ref) { has(policies(ref.output.value), cp) },
            ),
          )
        // checks config datum
        expect InlineDatum(datum) = configIn.output.datum
        expect cDatum: MerkelConfigDatum = datum

        // sends to loan validator in config
        expect Some(loanOut) =
          find(
            outputs,
            fn(output) {
              output.address.payment_credential == Script(cDatum.loanVal) && has(
                policies(output.value),
                policyId,
              )
            },
          )
        // sends to collateral validator in config
        expect Some(colOut) =
          find(
            outputs,
            fn(output) {
              output.address.payment_credential == Script(cDatum.colVal) && has(
                policies(output.value),
                policyId,
              )
            },
          )
        // checks loan output datum
        expect InlineDatum(datum) = loanOut.datum
        expect lDatum: LoanDatum = datum
        // checks collateral output datum
        expect InlineDatum(datum) = colOut.datum
        expect colDatum: CollateralDatum = datum
        let decimalComp = lDatum.amount * 1000
        let exchangeValue = decimalComp / exchangeRate
        // checks loan values against redeemer && collateral && 2 tokens minted
        lDatum.amount == amount && lDatum.term == term && colDatum.amount == amount * 2 && lovelace_of(
          colOut.value,
        ) >= exchangeValue * 1000000 && tAmt == 2 && lDatum.oracle == oracleTn && lDatum.rewards == rewards && lDatum.timestamp == timestamp && colDatum.yield == 0
      }
      // True
      // always allows Burn -> This needs to be changed to only allow burning when the loan is 
      // closed or there is no more loan value (ie liquidated)
      ABurn -> True
    }
  }

  else(_) {
    fail
  }
}
