export enum Contracts {
  Accounting = 'fund/accounting/Accounting',
  Engine = 'engine/Engine',
  FeeManager = 'fund/fees/FeeManager',
  FundFactory = 'factory/FundFactory',
  GenericExchange = 'exchanges/GenericExchange',
  Hub = 'fund/hub/Hub',
  MatchingMarket = 'exchanges/MatchingMarket',
  Participation = 'fund/participation/Participation',
  PolicyManager = 'fund/policies/PolicyManager',
  PreminedToken = 'dependencies/token/PreminedToken',
  Shares = 'fund/shares/Shares',
  Spoke = 'fund/shares/Spoke',
  StandardToken = 'dependencies/token/StandardToken',
  TestingPriceFeed = 'prices/TestingPriceFeed',
  Trading = 'fund/trading/Trading',
  Vault = 'fund/vault/Vault',
  VaultFactory = 'fund/vault/VaultFactory',
  Version = 'version/VersionInterface',
}

// HINT: Link the interfaces instead of the implementations wherever possible
// (to maintain extensibility)
// prettier-ignore
export const requireMap = {
  [Contracts.Accounting]:
    require('../out/fund/accounting/Accounting.abi.json'),
  [Contracts.Engine]:
    require('../out/engine/Engine.abi.json'),
  [Contracts.FeeManager]:
    require('../out/fund/fees/FeeManager.abi.json'),
  [Contracts.FundFactory]:
    require('../out/factory/FundFactory.abi.json'),
  [Contracts.GenericExchange]:
    require('../out/exchanges/GenericExchangeInterface.abi.json'),
  [Contracts.Hub]:
    require('../out/fund/hub/Hub.abi.json'),
  [Contracts.MatchingMarket]:
    require('../out/exchanges/thirdparty/oasisdex/MatchingMarket.abi.json'),
  [Contracts.Participation]:
    require('../out/fund/participation/ParticipationInterface.abi.json'),
  [Contracts.PolicyManager]:
    require('../out/fund/policies/PolicyManager.abi.json'),
  [Contracts.PreminedToken]:
    require('../out/dependencies/token/PreminedToken.abi.json'),
  [Contracts.Shares]:
    require('../out/fund/shares/Shares.abi.json'),
  [Contracts.Spoke]:
    require('../out/fund/hub/Spoke.abi.json'),
  [Contracts.StandardToken]:
    require('../out/dependencies/token/StandardToken.abi.json'),
  [Contracts.TestingPriceFeed]:
    require('../out/prices/TestingPriceFeed.abi.json'),
  [Contracts.Trading]:
    require('../out/fund/trading/Trading.abi.json'),
  [Contracts.Vault]:
    require('../out/fund/vault/Vault.abi.json'),
  [Contracts.VaultFactory]:
    require('../out/fund/vault/VaultFactory.abi.json'),
  // TODO: Don't use mockversion here. Does the real version also have a setFundFactory method?
  [Contracts.Version]:
      require('../out/version/MockVersion.abi.json'),
};
