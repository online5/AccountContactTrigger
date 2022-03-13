// Virtual Keyword Example
/*public virtual class Pen {
    public void Write()
    {
        System.debug('This is a non virtual method.');
    }
    public virtual void Write2()
    {
        System.debug('This is a virtual method by Pen Class');
    }
}*/


public abstract class Pen{
    
    public void Write()
    {
       System.debug('Pen class instance method Write'); 
    }
    public abstract void Write2();
    //public abstract void Write3();
}