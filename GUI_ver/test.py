import sys
import tkinter
import os

root = tkinter.Tk()
root.title(u"Software Title")
root.geometry("600x400")

files_dir=os.getcwd()

EditBox = tkinter.Entry(width=75)
EditBox.insert(tkinter.END,files_dir)
EditBox.pack()
EditBox.place(x=15, y=15)

sansho=tkinter.Button(text=u'参照')
sansho.pack()
sansho.place(x=480, y=10)

root.mainloop()
