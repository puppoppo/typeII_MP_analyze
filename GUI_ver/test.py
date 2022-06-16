import sys
import tkinter
import os
from tkinter import filedialog

def sanshofn(file_dir):
    typ = [('','*')]
    fle = filedialog.askopenfilename(filetypes = typ, initialdir = file_dir)


root = tkinter.Tk()
root.title(u"Software Title")
root.geometry("600x400")

file_dir=os.getcwd()

EditBox = tkinter.Entry(width=75)
EditBox.insert(tkinter.END,file_dir)
EditBox.pack()
EditBox.place(x=15, y=15)

sansho=tkinter.Button(text=u'参照',command=lambda:sanshofn(file_dir))
sansho.pack()
sansho.place(x=480, y=10)



root.mainloop()
