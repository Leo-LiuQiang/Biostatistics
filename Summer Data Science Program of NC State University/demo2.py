# Filename:demo2_list_dict_tuple.py
# Date: 07/19/2022
# Qiang Liu
# NCSU-GTI Summer 2022 Data Science
#------------------import library---------------------
import sys
import math
import os,io,csv
from datetime import date, datetime
#------------------global variables-------------------
dash = "-" * 80
print(dash)

def main():
    print("Start Program.....")
    now = datetime.now()
    current_date = datetime(now.year,now.month,now.day)
    #format
    print("Today:", current_date.strftime("%m/%d/%Y"))

    #LIST
    myList = [1,2,3]
    print(type(myList))
    print(myList)
    #animal list
    animals = ['cat','dog','monkey']
    print(animals)
    #call dog
    print(animals[1])
    #add Rabbit
    animals.append("Rabbit")
    print(animals)
    #add Giraffe before dog
    animals.insert(1,"Giraffe")
    print(animals)
    #remove monkey
    animals.remove("monkey")
    print(animals)
    #sort animals Capital will be sort first
    print("sort animals")
    animals.sort()
    print(animals)

    # sort animals reverse
    print("sort animals reverse")
    animals.sort(reverse=True)
    print(animals)
    #find the length of your list
    print(len(animals))
    #slice
    #rabbit and cat
    print(animals[1:3]) # n,m-1
    print(animals[1:])  #from 1 to end
    print(animals[:3])  #from m-1 to left
    print(animals[:-1])  #(0,1,2,3) = (-4,-3,-2,-1)

    #Activity: Sales
    Sales = [1111.23,34334.34,6576.44,9292.78]
    #1: sort the sales
    Sales.sort()
    print(Sales)
    #2: find the totals of sales
    print("Total of sales:$ %0.2f"%(sum(Sales)))
    #3: find the average of sales
    import numpy
    print("Average of sales:$ %0.2f"%(numpy.mean(Sales)))

    print(Sales)
    Sales.sort()
    print(Sales)
    total = 0.0
    for sale in Sales:
        total += sale
    print(f"Total Sales: ${total:,.2f}")
    print(f"Average Sales: ${total / len(Sales):,.2f}")

    #dictionary
    print(dash)
    myfriends = {"Name":'Zara',"Age":28,"Title":'Engineer'}
    print(type(myfriends))
    print(myfriends)
    print(myfriends["Title"])
    #print in loop
    for myfriend in myfriends:
        print(myfriends[myfriend])

    print(dash)
    print(myfriends.keys())
    print(myfriends.values())
    print(myfriends.items())

    #add school to Zara
    myfriends['School'] = 'NCSU'
    print(myfriends.items())

    #length
    print(len(myfriends))

    #in operator
    print("Address" in myfriends)
    print("School" in myfriends)

    #delete age
    del myfriends["Age"]
    print(myfriends.items())
    #clear
    myfriends.clear()
    print(myfriends.items())

#starting point... launch
# __name__ is predefined class attribute
if __name__ == '__main__':
    main()
