import React, { useState } from "react"
import { Tab, Box } from "@mui/material"
import { useEthers } from "@usedapp/core"
import { TabContext, TabList, TabPanel} from "@mui/lab"
import { Token } from "../Main"
import { StakeForm } from "./StakeForm"
interface YourWalletProps {
    supportedTokens: Array<Token>
}

export const YourWallet = ({ supportedTokens } : YourWalletProps) => {

    const [selectedTokenIndex, setSelectedTokenIndex] = useState<number>(0)
    const handleChange = (event: React.ChangeEvent<{}>, newValue: string) => {
        setSelectedTokenIndex(parseInt(newValue))
    }
    const { account } = useEthers()
    const isConnected = account !== undefined

    return (
        <div>
            {isConnected ? (
                <TabContext value= {selectedTokenIndex.toString()}>
                    <TabList onChange={handleChange}>
                        {supportedTokens.map((token, index) => {
                            return (
                                <Tab
                                    label={token.name}
                                    value={index.toString()}
                                    key={index} 
                                />
                            )
                        })}
                    </TabList>
                    {supportedTokens.map((token, index) => {
                        return (
                            <TabPanel value={index.toString()} key={index}>
                                <StakeForm token={supportedTokens[selectedTokenIndex]}/>
                            </TabPanel>
                        )
                    })}
                </TabContext>
            ) : 

            <div>Nope</div>

            }
        </div>
    )
}