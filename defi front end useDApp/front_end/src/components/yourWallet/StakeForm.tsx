
import { Button, Input } from "@mui/material"
import { Token } from "../Main"
import React, { useState } from  "react"
import {useStakeTokens} from "../../hooks"
import { utils } from "ethers"

export interface StakeFormProps{
    token: Token
}

export const StakeForm = ({ token }: StakeFormProps) => {
    const { address, name} = token
    const [amount, setAmount] = useState<number | string | Array<number | string>>(0)
    const handleInputChange = (event:React.ChangeEvent<HTMLInputElement>) => {
        const newAmount = event.target.value === "" ? "" : Number(event.target.value)
        setAmount(newAmount)
    }

    const { stakeTokens, stakeTokensState} = useStakeTokens(address)

    const handleStakeSubmit = () => {
        const amountAsWei = utils.parseEther(amount.toString())
        return stakeTokens(amountAsWei.toString())
    }

    return(
        <div>
            <Input 
                onChange={handleInputChange}
                value = {amount}
            />

            <Button
            onClick = {handleStakeSubmit}
            >
                Stake
            </Button>
        </div>
    )
}