#include <iostream>
#include <vector>
#include <string>
#include <fstream>
using namespace std;

// function that checks that the inputs are all digits and are 4 digits in total
bool allNumbersChecker(string number)
{
    if ((number.size() < 4) || (number.size() > 4))
        return false;
    for (char i : number)
    {
        if (isdigit(i))
            return true;
    }
    return false;
}
// function that turns all the letters in a word lowercase to make sure that whoever is searching or inputing doesn't get the result they want just because the capitalized
void allLowercase(string &word)
{
    for (int i = 0; i < word.size(); i++)
    {
        word[i] = tolower(word[i]);
    }
}
// function that turns the sentences in a file to a vector of each word
vector<string> sentenceToWordVector(string sentence)
{
    vector<string> tempvector;
    string word;
    for (int i = 0; i < sentence.length(); ++i)
    {
        if (sentence[i] == ' ')
        {
            tempvector.push_back(word);
            word = "";
        }
        else
            word.push_back(sentence[i]);
    }
    tempvector.push_back(word);
    return tempvector;
}
// class for the renters
class Renter
{
private:
    string renterID, renterName;

public:
    Renter()
    {
        renterName = "";
        renterID = "";
    }
    Renter(string renterName, string renterID)
    {
        this->renterName = renterName;
        this->renterID = renterID;
    }
    // setters and getters for all the attributes of the renter
    string getRenterName() { return renterName; }
    string getRenterID() { return renterID; }
    void setRenterName(string renterName) { this->renterName = renterName; }
    void setRenterID(string renterID) { this->renterID = renterID; }
};
// class for cars
class Car
{
private:
    string brand, model, year;
    Renter person;
    bool isRented = false;

public:
    Car()
    {
        brand = "";
        model = "";
        year = "";
    }
    Car(string brand, string model, string year)
    {
        this->brand = brand;
        this->model = model;
        this->year = year;
    }
    string getBrand() { return brand; }
    Renter get_person() { return person; }
    string getYear() { return year; }
    string getModel() { return model; }
    bool getIsRented()
    {
        if ((person.getRenterName() != "") && (person.getRenterID() != ""))
            isRented = true;
        return isRented;
    }
    // necessary setters and getters for the car brand 
    void setBrand(string brand) { this->brand = brand; }
    void setPerson(Renter person) { this->person = person; }
    void setYear(string year) { this->year = year; }
    void setModel(string model) { this->model = model; }
};
// carrental system class (All of us)
class CarRental
{
private:
    vector<Car> cars;
    vector<Renter> renters = {};
    vector<string> carlist, templist;

public:
    // The constructor for the system that takes all the cars from the file and and appends it to the vector accordingly 
    CarRental()
    {
        Car c;
        Renter r;
        ifstream tempFile;
        string data;
        tempFile.open("Cardata.txt");
        if (tempFile.peek(), tempFile.eof())
            throw "file is empty.";

        if (tempFile.fail())
            throw "file does not exist.";

        while (!tempFile.eof())
        {
            getline(tempFile, data);
            carlist.push_back(data);
        }

        for (int i = 0; i < carlist.size(); i++)
        {
            templist = sentenceToWordVector(carlist[i]);
            if (templist.size() == 3)
            {
                string brand = templist[0];
                string model = templist[1];
                string year = templist[2];
                c.setBrand(brand);
                c.setModel(model);
                c.setYear(year);
                r.setRenterName("");
                r.setRenterID("");
                c.setPerson(r);
                cars.push_back(c);
            }
            else if (templist.size() == 5)
            {
                string brand = templist[0];
                string model = templist[1];
                string year = templist[2];
                string renterID = templist[3];
                string renterName = templist[4];
                c.setBrand(brand);
                c.setModel(model);
                c.setYear(year);
                r.setRenterName(renterName);
                r.setRenterID(renterID);
                c.setPerson(r);
                cars.push_back(c);
            }
        }
    }
    // adds new cars to the vector list so they can later be used in other parts of the code
    void addCar(string brand, string model, string year)
    {
        Car car;
        car.setBrand(brand);
        car.setModel(model);
        car.setYear(year);
        cars.push_back(car);
        cout << "you car " << brand << " has been added successfully" << endl;
    }
    // searches for cars and states whether they are rented or not
    string searchCar(string brand, string model, string year)
    {
        for (Car i : cars)
        {
            Renter r = i.get_person();
            // searches for car using if statements and a loop
            if ((i.getBrand() == brand) && (i.getModel() == model) && (i.getYear() == year))
                // checks if the car is rented
                if (!i.getIsRented())
                    return brand + " " + model + " " + year + " found with no renters";
                else
                    return brand + " " + model + " " + year + " found and is rented by Name: " + r.getRenterName() + " ID: " + r.getRenterID();
        }
        // if there is no car it will just state that the car is not found
        return "Car not found";
    }
    // adds new renters to a vector so they can later be used to rent cars
    void addRenter(string renterName, string renterID)
    {
        // sets an empty Renter object to the inputed attributes and puts it in to the vector
        Renter renter;
        renter.setRenterName(renterName);
        renter.setRenterID(renterID);
        renters.push_back(renter);
        cout << endl
             << "Renter " << renterName << " added successfully" << endl;
    }
    // looks for unused renters and sets them to the cars they want to rent
    void rentCar(string brand, string model, string year, string renterName, string renterID)
    {
        int carfound = -1;
        // first loop that looks through the cars and finds the car the person has selected
        for (int i = 0; i < cars.size(); i++)
        {
            Car &tempcar = cars[i];
            if ((tempcar.getBrand() == brand) && (tempcar.getModel() == model) && (tempcar.getYear() == year))
                // if statement that checks the car is not rented before looking through the renter list
                if (!tempcar.getIsRented())
                {
                    carfound = i;
                    break;
                }
                else
                {
                    cout << endl
                         << "the car you have attempted to rent is already rented please select this option and try renting another car" << endl;
                }
        }
        // car variable to store the car we want to select
        Car &tempcar = cars[carfound];
        // renter variable that stores the renter if there is no such renter in the renter list
        Renter temprenter;
        // first if statement to check if the renter list is empty
        if ((renters.size() == 0))
        {
            temprenter.setRenterName(renterName);
            temprenter.setRenterID(renterID);
            cout << "New renter " << renterName << " successfully created" << endl;
            tempcar.setPerson(temprenter);
            cout << renterName << " has rented " << brand << " " << model << endl;
            return;
        }
        int renterindex = 1;
        // for loop so if the list is not empty it looks through the renters
        for (Renter r : renters)
        {
            // if the renter is found the object will be deleted from the vector and added to the selected car
            if ((r.getRenterName() == renterName) && (r.getRenterID() == renterID))
            {
                tempcar.setPerson(r);
                cout << renterName << " has rented " << brand << " " << model << endl;
                renters.erase(renters.begin() + (renterindex - 1));
                return;
            }
            // if the renter is not found and the end of the list has been reached a new renter will be created and added to the selected car
            else if ((renters.size() == renterindex))
            {
                temprenter.setRenterName(renterName);
                temprenter.setRenterID(renterID);
                cout << "New renter " << renterName << "successfully created";
                tempcar.setPerson(temprenter);
                cout << renterName << " has rented " << brand << " " << model << endl;
                return;
            }
            renterindex++;
        }
        // if the car is not found this error message will appear
        if (carfound == -1)
            cout << endl
                 << "Car not found" << endl;
    }
    // looks for renters adn swaps them out for a completely new rente
    string editRenter(string oldRenterName, string oldRenterId, string newRenterName, string newRenterId)
    {
        // for loop to look through the cars
        for (Car &i : cars)
        {
            Renter tempRenter = i.get_person();
            // if the renter is found they will be replaced by the new renter
            if ((tempRenter.getRenterID() == oldRenterId) && (tempRenter.getRenterName() == oldRenterName))
            {
                tempRenter.setRenterID(newRenterId);
                tempRenter.setRenterName(newRenterName);
                i.setPerson(tempRenter);
                return "Renter successfully changed from " + oldRenterName + " to " + newRenterName;
            }
        }
        // if the renter is not found this error message will appear
        return "Current renter not found";
    }
    // removes renters form cars so they can be rented at a later time by new renters
    void returnCar(string oldRenterName, string oldRenterId)
    {
        bool f = false;
        // loop to find car with the specified renter
        for (int i = 0; i < cars.size(); i++)
        {
            Car c = cars[i];
            Renter r = c.get_person();
            // if the renter is found they will be removed from the car
            if ((r.getRenterID() == oldRenterId) && (r.getRenterName() == oldRenterName))
            {
                r.setRenterID("");
                r.setRenterName("");
                c.setPerson(r);
                cars[i] = c;
                cout << endl
                     << "car has been returned successfully" << endl;
                return;
            }
        }
        // if they are not found they will be an error message that displayed
        if (!f)
            cout << endl
                 << "car is not rented" << endl;
    }
    // goes through the edited vector and writes it back in to the file so it can be saved
    void quitSave()
    {
        ofstream editedFile;
        editedFile.open("Cardata.txt");
        // loops through the car object
        for (Car i : cars)
        {
            Renter temprenter = i.get_person();
            // if there is no renter it will just add the car's attributes
            if ((temprenter.getRenterName() == "") && (temprenter.getRenterID() == ""))
                editedFile << i.getBrand() << " " << i.getModel() << " " << i.getYear() << endl;
            // if there is a renter it will ad both the car's and the renter's attributes
            else
                editedFile << i.getBrand() << " " << i.getModel() << " " << i.getYear() << " " << temprenter.getRenterID() << " " << temprenter.getRenterName() << endl;
        }
    }
};
// main function that runs all the methods required for the user's actions
int main()
{
    try
    {
        char choice;
        bool quit = false;
        CarRental system;
        string carBrandChoice, carModelChoice, carYearChoice;
        string renterNameChoice, renterIDChoice, newRenterNameChoice, newRenterIDChoice;
        while (!quit)
        {
            // list of menu items and what the user should do
            cout << "Main Menu" << endl;
            cout << "1. Add new car" << endl
                 << "2. Car Search" << endl
                 << "3. Add new renter" << endl
                 << "4. Rent a car" << endl
                 << "5. Edit a renter" << endl
                 << "6. Return car" << endl
                 << "7. Exit system" << endl
                 << "please input a number between 1-7 to select your pefered action: ";
            cin >> choice;
            // exception handling if the user decides to enter a non numeric item
            if (!isdigit(choice))
            {
                cout << "it seems you have selected a non numberic input please try choosing a number between 1-7" << endl;
                continue;
            }
            // all the cases the user can choose from
            switch (choice)
            {
            case '1':
                // inputs for the car function
                cout << "Select car brand: ";
                cin >> carBrandChoice;
                cout << "Select car model: ";
                cin >> carModelChoice;
                cout << "Select car year: ";
                cin >> carYearChoice;
                // exception handling to make sure all letters are lowercase
                allLowercase(carBrandChoice);
                allLowercase(carModelChoice);
                // exception handling to make sure the user inputs a 4 digit number for the year if not an error appears
                if (!allNumbersChecker(carYearChoice))
                {
                    cout << "Car year must be all numbers and has to be 4 digits, please reselect this option and try again" << endl;
                    break;
                }
                system.addCar(carBrandChoice, carModelChoice, carYearChoice);

                break;

            case '2':
                // inputs for search function
                cout << "Select car brand: ";
                cin >> carBrandChoice;
                cout << "Select car model: ";
                cin >> carModelChoice;
                cout << "Select car year: ";
                cin >> carYearChoice;
                // exception handling to make sure all letters are lowercase
                allLowercase(carBrandChoice);
                allLowercase(carModelChoice);
                // exception handling to make sure the user inputs a 4 digit number for the year if not an error appears
                if (!allNumbersChecker(carYearChoice))
                {
                    cout << "Car year must be all numbers and has to be 4 digits, please reselect this option and try again" << endl;
                    break;
                }
                cout << endl
                     << system.searchCar(carBrandChoice, carModelChoice, carYearChoice) << endl;
                break;
            case '3':
                // inputs for the addrenter function
                cout << "Create renter profile" << endl
                     << "Enter renter name: ";
                cin >> renterNameChoice;
                cout << "Enter renter ID: ";
                cin >> renterIDChoice;
                // exception handling to make sure all letters are lowercase
                allLowercase(renterNameChoice);
                // exception handling to make sure the user inputs a 4 digit number for the ID if not an error appears
                if (!allNumbersChecker(renterIDChoice))
                {
                    cout << "Renter ID must be all numbers and has to be 4 digits, please reselect this option and try again" << endl;
                    break;
                }
                system.addRenter(renterNameChoice, renterIDChoice);
                break;
            case '4':
                // inputs for the rent car function
                cout << "Select car brand: ";
                cin >> carBrandChoice;
                cout << "Select car model: ";
                cin >> carModelChoice;
                cout << "Select car year: ";
                cin >> carYearChoice;
                cout << "Create / Check renter profile" << endl
                     << "Enter renter name: ";
                cin >> renterNameChoice;
                cout << "Enter renter ID: ";
                cin >> renterIDChoice;
                // exception handling to make sure all letters are lowercase
                allLowercase(carBrandChoice);
                allLowercase(carModelChoice);
                allLowercase(renterNameChoice);
                // exception handling to make sure the user inputs a 4 digit number for the renter ID and year if not an error appears
                if (!allNumbersChecker(carYearChoice) || !allNumbersChecker(renterIDChoice))
                {
                    cout << "Car year and renter ID must be all numbers and has to be 4 digits, please reselect this option and try again" << endl;
                    break;
                }
                system.rentCar(carBrandChoice, carModelChoice, carYearChoice, renterNameChoice, renterIDChoice);
                break;
            case '5':
                // inputs for the edit renter function
                cout << "Enter renter name: ";
                cin >> renterNameChoice;
                cout << "Enter renter ID: ";
                cin >> renterIDChoice;
                cout << "Enter new Renter name: ";
                cin >> newRenterNameChoice;
                cout << "Enter new renter ID: ";
                cin >> newRenterIDChoice;
                // exception handling to make sure all letters are lowercase
                allLowercase(renterNameChoice);
                allLowercase(newRenterNameChoice);
                // exception handling to make sure the user inputs a 4 digit number for both renter IDs if not an error appears
                if (!allNumbersChecker(newRenterIDChoice) || !allNumbersChecker(renterIDChoice))
                {
                    cout << "Both renter IDs must be all numbers and has to be 4 digits, please reselect this option and try again" << endl;
                    break;
                }
                cout << endl
                     << system.editRenter(renterNameChoice, renterIDChoice, newRenterNameChoice, newRenterIDChoice) << endl
                     << endl;
                break;
            case '6':
                // inputs for the edit renter function
                cout << "Enter renter name: ";
                cin >> renterNameChoice;
                cout << "Enter renter ID: ";
                cin >> renterIDChoice;
                // exception handling to make sure all letters are lowercase
                allLowercase(renterNameChoice);
                // exception handling to make sure the user inputs a 4 digit number for renter ID if not an error appears
                if (!allNumbersChecker(renterIDChoice))
                {
                    cout << "Renter ID must be all numbers and has to be 4 digits, please reselect this option and try again" << endl;
                    break;
                }
                system.returnCar(renterNameChoice, renterIDChoice);
                break;
            case '7':
                // exits out of system and loop and saves to file using quitsave function
                cout << "thank you for using our program your progress has been saved" << endl;
                quit = true;
                system.quitSave();
                break;
            default:
                // if a user inputs a non numeric number or a number out of the range this error message will pop up
                cout << endl
                     << endl
                     << "it seems you have picked a number out of range or a non numeric input please make sure to pick a number between 1-7" << endl
                     << endl;
                break;
            }
        }
    }
    catch (const char *e)
    {
        cerr << e << endl;
    }
}
