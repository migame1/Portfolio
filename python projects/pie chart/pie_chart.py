from tkinter import *
import matplotlib.pyplot as plt

master = Tk()
subjects = []
present = []
css = ['BlueViolet', 'Brown', 'CadetBlue', 'Chartreuse', 'Chocolate', 'Coral', 'CornflowerBlu', 'Crimson', 'Cyan', 'DarkBlue', 'DarkCyan', 'DarkGoldenRo', 'DarkGray', 'DarkGrey', 'DarkGreen', 'DarkKhaki', 'DarkMagenta', 'DarkOrange', 'DarkOrchid', 'DarkRed', 'DarkSalmon', 'DarkSeaGreen', 'DarkSlateBlue', 'DarkSlateGray', 'DarkSlateGrey', 'DarkTurquoise', 'DarkViolet', 'DeepPink', 'DeepSkyBlue', 'DimGray', 'DimGrey', 'DodgerBlue', 'FireBrick']

def build():
    counter = 0
    colors = []
    explode = []
    labels = subjects
    sizes = present
    while len(sizes) > len(labels):
        try:
            sizes.pop(len(labels))
        except:
            pass
    while len(sizes) < len(labels):
        try:
            labels.pop(len(sizes))
        except:
            pass
    while len(explode) < len(labels):
        explode.append(0)
    for i in css:
        if counter < len(labels):
            colors.append(i)
            counter+=1
        else:
            break


    plt.pie(sizes, explode=explode, labels=labels, colors=colors, autopct='%1.1f%%', shadow=False, startangle=140)
    plt.axis('equal')
    plt.show()

def pie_setup():
    subjects.append(Enter.get())
    Enter.delete(0, END)

def present_setup():
    present.append(int(Enter.get()))
    Enter.delete(0, END)

def presents():
    set_present.destroy()
    set2 = Button(master, text="set", command=lambda: present_setup())
    set2.grid(row=0, column=1)
    done = Button(master, text="Done", command=lambda: build())
    done.grid(row=1, column=0)

Enter = Entry(master)
set = Button(master, text="set", command=lambda: pie_setup())
set_present = Button(master, text="set present", command=lambda: presents())
done =Button(master, text="Done", command=lambda: build())


Enter.grid(row=0,column=0)
set.grid(row=0,column=1)
set_present.grid(row=1,column=0)

master.mainloop()