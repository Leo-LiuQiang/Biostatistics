# Filename:demo1.py
# Date: 07/18/2022
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
#companyShipFees = 1


def PostDate():
    print("Hello from PostDate Function")
    now=datetime.now()
    print(now)
    print(dash)
    current_date = datetime(now.year,now.month,now.day)
    #format
    print("Today:", current_date.strftime("%m/%d/%Y"))
    print("Today:",current_date.strftime("%m/%d/%y"))
    print("Today:", current_date.strftime("%m-%d-%y"))
#Here are the most common ones:
#%Y: a year in 4 digits.
#%y: a year in 2 digits.
#%m: month in 2 digits.
#%B: full name of the month.
#%w: week number from 0 to 6.
#%A: full name of the weekday.
#%d: day of the month.
#%j: day of the year.


def CompanyData():
    global CompanyShipFees  # global variable to able to access the value everywhere
    print("Hello from CompanyData Function")
    CompanyName = input("Enter your Company Name?")
    CompanyCEO = input("Enter your Company CEO?")
    CompanyLocation = input("Enter your Company Locaiton?")
    CompanyShipFees = float(input("Enter your Company Shipfees?"))
    print("Comapany Name:", CompanyName,
          ".The CEO is:", CompanyCEO,
          ".Located at:", CompanyLocation,
          ".Shipping Fees per Kg with Taxes:", CompanyShipFees * 1.5,
          f".Shipping Fees per Kg with Taxes:${ CompanyShipFees * 1.5:,.5f}")
          #First f is format, Second f is float type

    print(f"Without taxes ${CompanyShipFees:,.2f} With taxes ${CompanyShipFees * 1.5:,.2f}")
    print(dash)


def RepeatFees():
    #loop
    for i in range(5):
        print(i*CompanyShipFees)
    print("With Extra Fees:\n")
    print(f"Without taxes ${CompanyShipFees:,.2f} With taxes ${CompanyShipFees * 1.5:,.2f}")


def main():
    print("Start Program.....")
    #print(sys.version_info)
    #print(sys.platform)
    #print(sys.__doc__)
    #print(dir(sys))
    #print(dash)
    #print(csv.__doc__)
    #print(dir(csv))
    PostDate()
    CompanyData()
    RepeatFees()


#starting point... launch
# __name__ is predefined class attribute
if __name__ == '__main__':
    main()