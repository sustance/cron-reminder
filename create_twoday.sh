#!/usr/bin/env python3 
import datetime
from dateutil.relativedelta import relativedelta

def is_weekend(date):
    return date.weekday() >= 5  # Saturday is 5, Sunday is 6

def is_holiday(date, holidays):
    return (date.month, date.day) in holidays

def get_working_day_before(date, holidays):
    current_date = date - datetime.timedelta(days=1)
    while is_weekend(current_date) or is_holiday(current_date, holidays):
        current_date -= datetime.timedelta(days=1)
    return current_date

def main():
    # List of holidays (month, day)
    holidays = [
        (12, 21), 
        (12, 25), 
        (12, 26),
        ( 1,  1), 
        ( 1, 29), 
        ( 1, 30), 
        ( 1, 31), 
        ( 4,  4), 
        ( 4, 18),
        ( 4, 19),
        ( 4, 21), 
        ( 5,  1), 
        ( 5,  5), 
        ( 5, 31), 
        ( 7,  1)
    ]

    # Reminder dates (month, day)
    today_dates = [ 
    (10, 25),
    (10, 30),
    (11,  4),
    (11,  5), 
    (11,  6), 
    (11, 11), 
    (11, 12), 
    (11, 20), 
    (11, 22), 
    (12,  2), 
    (12, 20), 
    (12, 24), 
    ( 1,  2)
    ]

    # Generate crontab entries # is 8am hk
    crontab_entries = [
        "# Following items autogenerated. Dont replace other CRON items"
    ]

    current_year = datetime.datetime.now().year

    for month, day in today_dates:
        today_date = datetime.datetime(current_year, month, day)
        
        # Calculate two working days before
        twodays_before = get_working_day_before(get_working_day_before(today_date, holidays), holidays)
        
        # Add twodays.sh entry  0 0 is 8.00 AM in HK
        crontab_entries.append(f"0 0 {twodays_before.day} {twodays_before.month} * /home/id2/.local/bin/twodays.sh > /dev/null 2>&1")
        
        # Add today.sh entry 0 0 is 8.00 AM in HK
        crontab_entries.append(f"0 0 {day} {month} * /home/id2/.local/bin/today.sh > /dev/null 2>&1")

    # Print crontab entries
    for entry in crontab_entries:
        print(entry)

if __name__ == "__main__":
    main()
