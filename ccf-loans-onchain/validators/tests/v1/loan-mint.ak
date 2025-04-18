use cardano/assets
use cardano/transaction.{InlineDatum, NoDatum, Transaction, placeholder}
use tests/tools as t
use tests/transactions.{
  collateralDatum, configDatumIn, loanDatum, loanMintActionMint, oracleDatum,
}
use v1/loan_mint

//                 //
// Loan Mint Tests //
//                 //

test loan_mint() {
  let test_owner = #"face"

  let oref = t.test_oref(#"face", 1)
  let cref = t.test_oref(#"cafe", 2)
  let rref = t.test_oref(#"dead", 6)

  let mintAction = loanMintActionMint(1000, 12, 1111111114)

  let loanMintedValue = assets.merge(t.loanTokenValue(), t.loanTokenValue())

  let configInDatum = configDatumIn()

  let loanDatum = loanDatum(1000, 0, 12, 1111111114, #"beef")
  let loanOutDatum = InlineDatum(loanDatum)
  let loanOutValue = t.loanTokenValue()

  let collateralDatum = collateralDatum(2000, 12, 0)
  let colOutDatum = InlineDatum(collateralDatum)
  let colOutValue = assets.merge(t.makeAdaValue(2002), t.loanTokenValue())

  let oracleInDatum = oracleDatum(2000, 11111112, 1000000, 200000, "USD")
  let oracleOutDatum = oracleDatum(1000, 11111114, 1000000, 200000, "USD")
  let oInDatum = InlineDatum(oracleInDatum)
  let oOutDatum = InlineDatum(oracleOutDatum)

  let noDatum = NoDatum

  let userIn =
    t.test_input(
      oref,
      t.test_output(t.test_address(#"cafe"), t.makeAdaValue(2010), noDatum),
    )

  let configIn =
    t.test_input(
      cref,
      t.test_output(
        t.test_script_address(t.configValHash),
        t.configValue(),
        configInDatum,
      ),
    )

  let oracleIn =
    t.test_input(
      rref,
      t.test_output(
        t.test_script_address(t.oracleValHash),
        t.oracleValue(),
        oInDatum,
      ),
    )

  let oracleOut =
    t.test_output(
      t.test_script_address(t.oracleValHash),
      t.oracleValue(),
      oOutDatum,
    )

  let loanOut =
    t.test_output(
      t.test_script_address(t.merkelLoanSpend),
      loanOutValue,
      loanOutDatum,
    )

  let colOut =
    t.test_output(
      t.test_script_address(t.merkelCollateralSpend),
      colOutValue,
      colOutDatum,
    )

  let tx =
    Transaction {
      ..placeholder,
      reference_inputs: [configIn],
      mint: loanMintedValue,
      extra_signatories: [test_owner],
      inputs: [userIn, oracleIn],
      outputs: [loanOut, colOut, oracleOut],
    }

  loan_mint.loanMint.mint(
    t.oracleMintHash,
    t.configMintHash,
    mintAction,
    t.loanMintHash,
    tx,
  )?
}

test mint_loanDatumFail() fail {
  let test_owner = #"face"

  let oref = t.test_oref(#"face", 1)
  let cref = t.test_oref(#"cafe", 2)
  let rref = t.test_oref(#"dead", 6)

  let mintAction = loanMintActionMint(1000, 12, 1111111114)

  let loanMintedValue = assets.merge(t.loanTokenValue(), t.loanTokenValue())

  let configInDatum = configDatumIn()

  let loanDatum = loanDatum(500, 0, 12, 1111111114, #"beef")
  let loanOutDatum = InlineDatum(loanDatum)
  let loanOutValue = t.loanTokenValue()

  let collateralDatum = collateralDatum(2000, 12, 0)
  let colOutDatum = InlineDatum(collateralDatum)
  let colOutValue = assets.merge(t.makeAdaValue(2002), t.loanTokenValue())

  let oracleInDatum = oracleDatum(2000, 11111112, 1000000, 200000, "USD")
  let oracleOutDatum = oracleDatum(1000, 11111114, 1000000, 200000, "USD")
  let oInDatum = InlineDatum(oracleInDatum)
  let oOutDatum = InlineDatum(oracleOutDatum)

  let noDatum = NoDatum

  let userIn =
    t.test_input(
      oref,
      t.test_output(t.test_address(#"cafe"), t.makeAdaValue(2010), noDatum),
    )

  let configIn =
    t.test_input(
      cref,
      t.test_output(
        t.test_script_address(t.configValHash),
        t.configValue(),
        configInDatum,
      ),
    )

  let oracleIn =
    t.test_input(
      rref,
      t.test_output(
        t.test_script_address(t.oracleValHash),
        t.oracleValue(),
        oInDatum,
      ),
    )

  let oracleOut =
    t.test_output(
      t.test_script_address(t.oracleValHash),
      t.oracleValue(),
      oOutDatum,
    )

  let loanOut =
    t.test_output(
      t.test_script_address(t.merkelLoanSpend),
      loanOutValue,
      loanOutDatum,
    )

  let colOut =
    t.test_output(
      t.test_script_address(t.merkelCollateralSpend),
      colOutValue,
      colOutDatum,
    )

  let tx =
    Transaction {
      ..placeholder,
      reference_inputs: [configIn],
      mint: loanMintedValue,
      extra_signatories: [test_owner],
      inputs: [userIn, oracleIn],
      outputs: [loanOut, colOut, oracleOut],
    }

  loan_mint.loanMint.mint(
    t.oracleMintHash,
    t.configMintHash,
    mintAction,
    t.loanMintHash,
    tx,
  )
}

test mint_colDatumFail() fail {
  let test_owner = #"face"

  let oref = t.test_oref(#"face", 1)
  let cref = t.test_oref(#"cafe", 2)
  let rref = t.test_oref(#"dead", 6)

  let mintAction = loanMintActionMint(1000, 12, 1111111114)

  let loanMintedValue = assets.merge(t.loanTokenValue(), t.loanTokenValue())

  let configInDatum = configDatumIn()

  let loanDatum = loanDatum(1000, 0, 12, 1111111114, #"beef")
  let loanOutDatum = InlineDatum(loanDatum)
  let loanOutValue = t.loanTokenValue()

  let collateralDatum = collateralDatum(1000, 12, 0)
  let colOutDatum = InlineDatum(collateralDatum)
  let colOutValue = assets.merge(t.makeAdaValue(2002), t.loanTokenValue())

  let oracleInDatum = oracleDatum(2000, 11111112, 1000000, 200000, "USD")
  let oracleOutDatum = oracleDatum(1000, 11111114, 1000000, 200000, "USD")
  let oInDatum = InlineDatum(oracleInDatum)
  let oOutDatum = InlineDatum(oracleOutDatum)

  let noDatum = NoDatum

  let userIn =
    t.test_input(
      oref,
      t.test_output(t.test_address(#"cafe"), t.makeAdaValue(2010), noDatum),
    )

  let configIn =
    t.test_input(
      cref,
      t.test_output(
        t.test_script_address(t.configValHash),
        t.configValue(),
        configInDatum,
      ),
    )

  let oracleIn =
    t.test_input(
      rref,
      t.test_output(
        t.test_script_address(t.oracleValHash),
        t.oracleValue(),
        oInDatum,
      ),
    )

  let oracleOut =
    t.test_output(
      t.test_script_address(t.oracleValHash),
      t.oracleValue(),
      oOutDatum,
    )

  let loanOut =
    t.test_output(
      t.test_script_address(t.merkelLoanSpend),
      loanOutValue,
      loanOutDatum,
    )

  let colOut =
    t.test_output(
      t.test_script_address(t.merkelCollateralSpend),
      colOutValue,
      colOutDatum,
    )

  let tx =
    Transaction {
      ..placeholder,
      reference_inputs: [configIn],
      mint: loanMintedValue,
      extra_signatories: [test_owner],
      inputs: [userIn, oracleIn],
      outputs: [loanOut, colOut, oracleOut],
    }

  loan_mint.loanMint.mint(
    t.oracleMintHash,
    t.configMintHash,
    mintAction,
    t.loanMintHash,
    tx,
  )
}

test mint_actionFail() fail {
  let test_owner = #"face"

  let oref = t.test_oref(#"face", 1)
  let cref = t.test_oref(#"cafe", 2)
  let rref = t.test_oref(#"dead", 6)

  let mintAction = loanMintActionMint(500, 12, 1111111114)

  let loanMintedValue = assets.merge(t.loanTokenValue(), t.loanTokenValue())

  let configInDatum = configDatumIn()

  let loanDatum = loanDatum(1000, 0, 12, 1111111114, #"beef")
  let loanOutDatum = InlineDatum(loanDatum)
  let loanOutValue = t.loanTokenValue()

  let collateralDatum = collateralDatum(2000, 12, 0)
  let colOutDatum = InlineDatum(collateralDatum)
  let colOutValue = assets.merge(t.makeAdaValue(2002), t.loanTokenValue())

  let oracleInDatum = oracleDatum(2000, 11111112, 1000000, 200000, "USD")
  let oracleOutDatum = oracleDatum(1000, 11111114, 1000000, 200000, "USD")
  let oInDatum = InlineDatum(oracleInDatum)
  let oOutDatum = InlineDatum(oracleOutDatum)

  let noDatum = NoDatum

  let userIn =
    t.test_input(
      oref,
      t.test_output(t.test_address(#"cafe"), t.makeAdaValue(2010), noDatum),
    )

  let configIn =
    t.test_input(
      cref,
      t.test_output(
        t.test_script_address(t.configValHash),
        t.configValue(),
        configInDatum,
      ),
    )

  let oracleIn =
    t.test_input(
      rref,
      t.test_output(
        t.test_script_address(t.oracleValHash),
        t.oracleValue(),
        oInDatum,
      ),
    )

  let oracleOut =
    t.test_output(
      t.test_script_address(t.oracleValHash),
      t.oracleValue(),
      oOutDatum,
    )

  let loanOut =
    t.test_output(
      t.test_script_address(t.merkelLoanSpend),
      loanOutValue,
      loanOutDatum,
    )

  let colOut =
    t.test_output(
      t.test_script_address(t.merkelCollateralSpend),
      colOutValue,
      colOutDatum,
    )

  let tx =
    Transaction {
      ..placeholder,
      reference_inputs: [configIn],
      mint: loanMintedValue,
      extra_signatories: [test_owner],
      inputs: [userIn, oracleIn],
      outputs: [loanOut, colOut, oracleOut],
    }

  loan_mint.loanMint.mint(
    t.oracleMintHash,
    t.configMintHash,
    mintAction,
    t.loanMintHash,
    tx,
  )
}

test mint_oracleFail() fail {
  let test_owner = #"face"

  let oref = t.test_oref(#"face", 1)
  let cref = t.test_oref(#"cafe", 2)
  let rref = t.test_oref(#"dead", 6)

  let mintAction = loanMintActionMint(1000, 12, 1111111114)

  let loanMintedValue = assets.merge(t.loanTokenValue(), t.loanTokenValue())

  let configInDatum = configDatumIn()

  let loanDatum = loanDatum(1000, 0, 12, 1111111114, #"beef")
  let loanOutDatum = InlineDatum(loanDatum)
  let loanOutValue = t.loanTokenValue()

  let collateralDatum = collateralDatum(2000, 12, 0)
  let colOutDatum = InlineDatum(collateralDatum)
  let colOutValue = assets.merge(t.makeAdaValue(2002), t.loanTokenValue())

  let oracleInDatum = oracleDatum(2000, 11111112, 1000000, 200000, "USD")
  let oracleOutDatum = oracleDatum(1000, 11111114, 1000000, 200000, "USD")
  let oInDatum = InlineDatum(oracleInDatum)
  let oOutDatum = InlineDatum(oracleOutDatum)

  let noDatum = NoDatum

  let userIn =
    t.test_input(
      oref,
      t.test_output(t.test_address(#"cafe"), t.makeAdaValue(2010), noDatum),
    )

  let configIn =
    t.test_input(
      cref,
      t.test_output(
        t.test_script_address(t.configValHash),
        t.configValue(),
        configInDatum,
      ),
    )

  let oracleIn =
    t.test_input(
      rref,
      t.test_output(
        t.test_script_address(t.oracleValHash),
        t.oracleValue(),
        oInDatum,
      ),
    )

  let oracleOut =
    t.test_output(
      t.test_script_address(t.oracleValHash),
      t.configValue(),
      oOutDatum,
    )

  let loanOut =
    t.test_output(
      t.test_script_address(t.merkelLoanSpend),
      loanOutValue,
      loanOutDatum,
    )

  let colOut =
    t.test_output(
      t.test_script_address(t.merkelCollateralSpend),
      colOutValue,
      colOutDatum,
    )

  let tx =
    Transaction {
      ..placeholder,
      reference_inputs: [configIn],
      mint: loanMintedValue,
      extra_signatories: [test_owner],
      inputs: [userIn, oracleIn],
      outputs: [loanOut, colOut, oracleOut],
    }

  loan_mint.loanMint.mint(
    t.oracleMintHash,
    t.configMintHash,
    mintAction,
    t.loanMintHash,
    tx,
  )
}

test collateral_ValueFail() {
  let test_owner = #"face"

  let oref = t.test_oref(#"face", 1)
  let cref = t.test_oref(#"cafe", 2)
  let rref = t.test_oref(#"dead", 6)

  let mintAction = loanMintActionMint(1000, 12, 1111111114)

  let loanMintedValue = assets.merge(t.loanTokenValue(), t.loanTokenValue())

  let configInDatum = configDatumIn()

  let loanDatum = loanDatum(1000, 0, 12, 1111111114, #"beef")
  let loanOutDatum = InlineDatum(loanDatum)
  let loanOutValue = t.loanTokenValue()

  let collateralDatum = collateralDatum(2000, 12, 0)
  let colOutDatum = InlineDatum(collateralDatum)
  let colOutValue = assets.merge(t.makeAdaValue(1002), t.loanTokenValue())

  let oracleInDatum = oracleDatum(2000, 11111112, 1000000, 200000, "USD")
  let oracleOutDatum = oracleDatum(1000, 11111114, 1000000, 200000, "USD")
  let oInDatum = InlineDatum(oracleInDatum)
  let oOutDatum = InlineDatum(oracleOutDatum)

  let noDatum = NoDatum

  let userIn =
    t.test_input(
      oref,
      t.test_output(t.test_address(#"cafe"), t.makeAdaValue(2010), noDatum),
    )

  let configIn =
    t.test_input(
      cref,
      t.test_output(
        t.test_script_address(t.configValHash),
        t.configValue(),
        configInDatum,
      ),
    )

  let oracleIn =
    t.test_input(
      rref,
      t.test_output(
        t.test_script_address(t.oracleValHash),
        t.oracleValue(),
        oInDatum,
      ),
    )

  let oracleOut =
    t.test_output(
      t.test_script_address(t.oracleValHash),
      t.oracleValue(),
      oOutDatum,
    )

  let loanOut =
    t.test_output(
      t.test_script_address(t.merkelLoanSpend),
      loanOutValue,
      loanOutDatum,
    )

  let colOut =
    t.test_output(
      t.test_script_address(t.merkelCollateralSpend),
      colOutValue,
      colOutDatum,
    )

  let tx =
    Transaction {
      ..placeholder,
      reference_inputs: [configIn],
      mint: loanMintedValue,
      extra_signatories: [test_owner],
      inputs: [userIn, oracleIn],
      outputs: [loanOut, colOut, oracleOut],
    }

  trace @"VULNERABILITY"
  trace @"We should be checking collateral matches expected collateral"
  loan_mint.loanMint.mint(
    t.oracleMintHash,
    t.configMintHash,
    mintAction,
    t.loanMintHash,
    tx,
  )?
}
