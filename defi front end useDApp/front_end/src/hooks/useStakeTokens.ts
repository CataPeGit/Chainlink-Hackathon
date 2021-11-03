import TokenFarm from "../chain-info/TokenFarm.json"
import { useEthers } from "@usedapp/core"
import { utils, constants } from "ethers"
import networkMapping from "../chain-info/map.json"
import { Contract } from "@ethersproject/contracts"

export const useStakeTokens = (tokenAddress: string) => {
    const {chainId} = useEthers()
    const { abi } = TokenFarm
    const tokenFarmContractAddress = chainId ? networkMapping["kovan"]["TokenFarm"][0] : constants.AddressZero
    const tokenFarmInterface = new utils.Interface(abi)
    const tokenFarmContract = new Contract(
        tokenFarmContractAddress,
        tokenFarmInterface
    )

    const {send: stakeTokens, state: stakeTokensState} =  useContractFunction(tokenFarmContract, "stakeTokens" , {
        transactionName: "Stake Tokens"
    })
    return { stakeTokens, stakeTokensState}
}