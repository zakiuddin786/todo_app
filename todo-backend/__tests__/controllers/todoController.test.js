const todoController = require("../../contollers/todoController")

jest.mock("../../models/todoModel.js")

const mockSave = jest.fn();
const mockFind = jest.fn();

const Todo = require("../../models/todoModel")

Todo.find = mockFind
Todo.mockImplementation(()=>({
    save: mockSave
}))

describe("When Todo Controller Is invoked", () =>{
    let req, res;

    beforeEach(()=>{
        req = {
            body: {},
            params: {}
        };
        res = {
            json: jest.fn(()=>res),
            status: jest.fn(()=>res),
        }
    })

    describe("For getTodos function", () =>{
        it("Should return me all the todos, If everything goes right, ", async ()=>{
            const mockTodos = [{_id: 0, title: "Todo 1", completed: false},{_id: 1, title: "Todo 2", completed: false}, {_id: 2, title: "Todo 3", completed: false}]
            mockFind.mockResolvedValue(mockTodos)
            await todoController.getTodos(req,res);

            expect(mockFind).toHaveBeenCalled()
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith(mockTodos)
        })

        it("Should handle errors, If something goes wrong ", async () =>{
            const errorMessage = "something went wrong, please try later";
            mockFind.mockRejectedValue(new Error(errorMessage))

            await todoController.getTodos(req,res);
            expect(mockFind).toHaveBeenCalled()
            expect(res.status).toHaveBeenCalledWith(500);
            expect(res.json).toHaveBeenCalledWith({message: errorMessage})
        })
    })

    describe("For addTodo Function", () =>{
        it("should create a new Todo", async () =>{
            const newTodo = {_id: "1", title: "New Todo"}
            req.body = {title: "New Todo"}
            mockSave.mockResolvedValue(newTodo)

            await todoController.addTodo(req,res)

            expect(mockSave).toHaveBeenCalled();
            expect(res.status).toHaveBeenCalledWith(200)
            expect(res.json).toHaveBeenCalledWith(newTodo)

        })

        it("should handle the errors", async ()=>{
            const errorMessage = "something went wrong, please try later";
            mockSave.mockRejectedValue(new Error(errorMessage))

            await todoController.addTodo(req,res);
            expect(mockFind).toHaveBeenCalled()
            expect(res.status).toHaveBeenCalledWith(500);
            expect(res.json).toHaveBeenCalledWith({message: errorMessage})
        })
    })
})