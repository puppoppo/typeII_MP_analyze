import sys
import tkinter

root = tkinter.Tk()
root.title(u"Software Title")
root.geometry("400x300")

Static1 = tkinter.Label(text=u'test', foreground='#ff0000', background='#ffaacc')
Static1.place(x=150, y=228)

EditBox = tkinter.Entry()
EditBox.pack()

root.mainloop()
