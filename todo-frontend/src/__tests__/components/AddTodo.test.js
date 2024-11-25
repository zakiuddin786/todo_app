import React from "react"

import {render, fireEvent, screen} from "@testing-library/react"
import AddTodo from "../../components/AddTodo"


describe("Testing the Add Todo component", ()=>{
    test("Render the input field and add button", ()=>{
        render(<AddTodo onAdd={() =>{}}/>)
        expect(screen.getByPlaceholderText("Add a new Todo")).toBeInTheDocument();
    })
})