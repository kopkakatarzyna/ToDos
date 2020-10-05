import Foundation

var textField:String?=""
var checkBox:Int = 0
var remoteTodos: [[String : Any]] = [["id": 1, "title": "delectus aut autem", "completed": 0],
                                     ["id": 2, "title": "quis ut nam facilis et officia qui", "completed": 0],
                                     ["id": 3, "title": "fugiat veniam minus", "completed": 1],
                                     ["id": 4, "title": "et porro tempora", "completed": 1],
                                     ["id": 5, "title": "laboriosam mollitia et enim quasi adipisci quia provident illum", "completed": 0],
                                     ["id": 6, "title": "qui ullam ratione quibusdam voluptatem quia omnis", "completed": 0],
                                     ["id": 7, "title": "illo expedita consequatur quia in", "completed": 0],
                                     ["id": 8, "title": "quo adipisci enim quam ut ab", "completed": 1],
                                     ["id": 9, "title": "molestiae perspiciatis ipsa", "completed": 0],
                                     ["id": 10, "title": "illo est ratione doloremque quia maiores aut", "completed": 1]]
var lastID:Int = remoteTodos.endIndex+1

// sprawdzanie, czy jest mozliwa konwersja ze String na Int
// zrodlo: https://stackoverflow.com/a/38160725
extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

class TodoViewControler {

    // funkcja umozliwiajaca porownanie typow Any
    // zrodlo: https://stackoverflow.com/a/34779078
    func isEqual<T: Equatable>(type: T.Type, a: Any, b: Any) -> Bool {
      guard let a = a as? T, let b = b as? T else { return false }

      return a == b
    }

    //funkcja sprawdzajaca, czy lancuch znakow sklada sie tylko z bialych znakow
    func isStringBlank(bText:String)->Bool{
      var white:Bool = true
      for ch in bText{
        if ch != " " && ch != "\t" && ch != "\n" && ch != "\r"{
        white = false
        break
        }
      }
      return white
    }

    //funkcja sprawdzajaca, czy argument spelnia wymogi: nie jest nil i nie sklada sie tylko z bialych znakow
    func isTextValid(vText: String?)-> Bool{
      if vText != nil && !isStringBlank(bText: vText!) {
        return true
      }
      else{
        return false
      }
    }
    
    //funkcja imitujaca interfejs zwracania textu z textfield, pobierajaca text z konsoli
    func fillImaginaryTextField(){
      textField = ""
      print("\nAdding new task")
      print("Please enter non-empty title:")
      textField = readLine()
      if isTextValid(vText: textField){
        toggleImaginaryCheckbox()
        imaginaryButtonActionAddNewToDo()
        return
      }
      else{
        print("\nInvalid input. Please try again")
        fillImaginaryTextField()
        return
      }
    }

    //funkcja imitujaca interfejs zwracania textu z textfield, pobierajaca text z argumentu funkcji
    func fillImaginaryTextField(with text: String?) {
      if isTextValid(vText: text){
        textField=text
        print("Adding new task with title from function: \(text!)")
        checkBox = 0
        imaginaryButtonActionAddNewToDo()
      }
      else{
        print("\nTitle given in function is not valid.")
      }
      return
    }
    
    //funkcja imitujaca interfejs przelaczenia checkbox
    func toggleImaginaryCheckbox() {
      print("\nEnter 1 if checked, 0 otherwise:")
      let checkString = readLine()
      guard checkString=="0" || checkString=="1" else{
        print("You can only enter 0 or 1. Please try again")
        toggleImaginaryCheckbox()
        return
      }
      checkBox = (Int(checkString!))!
      return
    }
    
    //funkcja imitujaca przycisniecie przycisku AddNewToDo, pobierajaca tytul z konsoli
    func imaginaryButtonActionAddNewToDo() {
      let newDict = ["id": lastID as Any, "title":textField! as Any, "completed":checkBox as Any]
      remoteTodos.append(newDict)
      print("\nNew task added: ID \(lastID) \(textField!)")
      textField=""
      lastID += 1
      return
    }

    //funkcja imitujaca przycisniecie przycisku RemoveTodo dla obiektu z id, pobierajaca id z konsoli
    func imaginaryButtonActionRemoveTodo() {
      var stringID:String?
      var consoleId:Int
      print("\nRemoving task - please enter ID:")
      stringID = readLine()
      guard stringID != nil && stringID!.isInt else{
        print("Entered ID is not valid. Please try again")
        imaginaryButtonActionRemoveTodo()
        return
      }
      consoleId=(Int(stringID!))!
      imaginaryButtonActionRemoveTodo(with: consoleId)
    }

    //funkcja imitujaca przycisniecie przycisku RemoveTodo dla obiektu z id, pobierajaca id z argumentu funkcji
    func imaginaryButtonActionRemoveTodo(with id:Int) {
      print("\nRemoving task - entered ID: \(id)")
      for (index,dict) in remoteTodos.enumerated(){
        for elemInDict in dict{
          if elemInDict.key=="id"{
            if isEqual(type: Int.self, a: elemInDict.value, b: id){
              remoteTodos.remove(at: index)
              print("\nTask ID \(id) removed.")
              return
            }
          }
        }
      }
      print("Given ID not found.")
      return
    }

    //funkcja imitujaca przelaczenie checkbox dla obiektu z id, pobierajaca id z konsoli
    func imaginaryButtonActionToggleTodo() {
      var stringID:String?
      var consoleId:Int
      print("\nChanging status of task - please enter ID:")
      stringID = readLine()
      guard stringID != nil && stringID!.isInt else{
        print("Entered ID is not valid. Please try again")
        imaginaryButtonActionToggleTodo()
        return
      }
      consoleId=(Int(stringID!))!
      imaginaryButtonActionToggleTodo(with: consoleId)
    }
    
    //funkcja imitujaca przelaczenie checkbox dla obiektu z id pobierajaca id z argumentu funkcji
    func imaginaryButtonActionToggleTodo(with id: Int) {
      print("\nChanging status of task, ID: \(id)")
      for (index,dict) in remoteTodos.enumerated(){
        for elemInDict in dict{
          if elemInDict.key=="id"{
            if isEqual(type: Int.self, a: elemInDict.value, b: id){
              if isEqual(type: Int.self, a: remoteTodos[index]["completed"]!, b: 0){
                remoteTodos[index]["completed"]=1
                print("\nStatus changed to: completed")
              }
              else{
                remoteTodos[index]["completed"]=0
                print("\nStatus changed to: not completed")
              }
              return
            }
          }
        }
      }
      print("Given ID not found.")
      return
    }

    func display(){
      print()
      for elem in remoteTodos{
        print("ID \(elem["id"]!): \(elem["title"]!); checked: \(elem["completed"]!)")
      }
    }
}

// klasa pozwalajaca wykonywac operacje na ToDos z poziomu konsoli
class TodoManager{
  let control = TodoViewControler()

  func manage(){
    print("\nWhat to do? \nd - display ToDos\na - add new task\nc - change status of task\nr - remove task\nx - exit")
    let whatToDo:String? = readLine()
    guard whatToDo != nil else{
      print("\nInvalid input. Please try again")
      manage()
      return
    }
    switch whatToDo! {
      case "d":
        control.display()
        break;
      case "a":
        control.fillImaginaryTextField()
        break;
      case "c":
        control.imaginaryButtonActionToggleTodo()
        break;
      case "r":
        control.imaginaryButtonActionRemoveTodo()
        break;
      case "x":
        print("Exiting...")
        return
      default:
        print("\nNo such option available. Please try again")
    }
    manage()
  }
}

// prezentacja zarzadzania operacjami na ToDos z poziomu funkcji
let toDo = TodoManager()
print("\nDisplaying ToDos:")
toDo.control.display()
print("\nAdding new task by using function:")
toDo.control.fillImaginaryTextField(with: "wash the dishes")
toDo.control.display()
print("\nTrying to add new task by using function with invalid title:")
toDo.control.fillImaginaryTextField(with: "")
toDo.control.display()
print("\nChanging status of added task:")
toDo.control.imaginaryButtonActionToggleTodo(with: 11)
toDo.control.display()
print("\nUnchecking task 4:")
toDo.control.imaginaryButtonActionToggleTodo(with: 4)
toDo.control.display()
print("\nTrying to change status of non-existing task:")
toDo.control.imaginaryButtonActionToggleTodo(with: 1500)
toDo.control.display()
print("\nRemoving task:")
toDo.control.imaginaryButtonActionRemoveTodo(with: 4)
toDo.control.display()
print("\nTrying to remove non-existing task:")
toDo.control.imaginaryButtonActionRemoveTodo(with: 200)
toDo.control.display()

// zarzadzanie operacjami na ToDos z poziomu konsoli
toDo.manage()
