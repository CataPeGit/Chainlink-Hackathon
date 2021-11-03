import { ChainId } from "@usedapp/core"
import { YourWallet } from "./yourWallet/YourWallet"
import { useEthers } from "@usedapp/core"
import networkMapping from "../chain-info/map.json"
import { constants } from "ethers"
import brownieConfig from "./brownie-config-json.json"

export type Token = {
    // image: string
    address: string
    name: string
}


export const Main = () => {

    const { chainId } = useEthers()

    const dappTokenAddress = chainId ? networkMapping[String(chainId)]["DappToken"][0] : constants.AddressZero
    const wethTokenAddress = chainId ? brownieConfig["networks"]["kovan"]["weth_token"] : constants.AddressZero 


    const supportedTokens: Array<Token> = [
        {
            address: wethTokenAddress,
            name: "WETH"
        },
        {
            address: dappTokenAddress,
            name: "DAPP"
        }
    ]
    // At the top, show our balances and a stake button
      // At the bottom show our staked balances and unstake button

    return (
        <div>
            <YourWallet supportedTokens = {supportedTokens} />
        </div>
    )

}    