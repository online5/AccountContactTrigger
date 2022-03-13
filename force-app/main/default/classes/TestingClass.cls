public class TestingClass {
    public static Integer myValue = 0;  //Class Member variable
    public static String myString = ''; //Class Member variable
    
    public static Integer getCalculatedValue () {
        // Method definition and body
        // do some calculation
        // Adding this line from VS CODE
        myValue = myValue+10;
        return myValue;
    }
    

    
    
}