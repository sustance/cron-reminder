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
    # HongKong TOP
    # Vaduz BOT extra in addtion to HK
    holidays = [
        (12, 26), (1, 1), (1, 29), (1, 30), (1, 31), (4, 4), (5, 1), (5, 5), (5, 31), (7, 1),
        (1, 2), (1, 6), (2, 2), (3, 19), (5, 29), (6, 9), (6, 19)
    ]

    # Original today.sh dates
    today_dates = [
        (12, 27), (12, 30), (12, 31), (1, 2), (1, 3), (1, 6), (1, 9), (1, 25), (1, 27), (1, 29), (2, 14) 
    ]

    # Generate crontab entries
    crontab_entries = [
        # do not remove other entries
                    ]

    current_year = datetime.datetime.now().year

    for month, day in today_dates:
        today_date = datetime.datetime(current_year, month, day)
        
        # Calculate three working days before
        #twodays_before = get_working_day_before(get_working_day_before(today_date, holidays), holidays)
        threedays_before = get_working_day_before(get_working_day_before(get_working_day_before(today_date, holidays), holidays), holidays)
        # Add threedays.sh entry
        crontab_entries.append(f"0 1 {threedays_before.day} {threedays_before.month} * /home/id2/.local/bin/threedays.sh >/dev/null 2>&1")
        # Add today.sh entry
        crontab_entries.append(f"0 1 {day} {month} * /home/id2/.local/bin/today.sh >/dev/null 2>&1")

    # Print crontab entries
    for entry in crontab_entries:
        print(entry)

if __name__ == "__main__":
    main()
