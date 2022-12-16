import os
#import system, name
import time
from time import gmtime
import pandas as pd
import numpy

# create dictoary
CITY_DATA = { 'chicago': 'chicago.csv',
              'new york': 'new_york_city.csv',
              'washington': 'washington.csv' }
MONTHS = ['january', 'february', 'march', 'april', 'may', 'june','all']
DAYS = ['saturday', 'sunday', 'monday', 'tuesday', 'wednessday', 'thursday', 'friday','all']
CITIES = list(CITY_DATA.keys())
CHOICES = ['yes','no','y','n']
#def validate( value)
#    value = 0
#    while not value
#    if value
def ask_input(input_name, input_list):
    feat = None
    while not feat:
        feat = input(f"What is the {input_name} you want data about choose from\n{input_list}?\n").lower()
        if feat not in input_list:
            print("SORRY Please Make a LEGAL choice:")
            feat = None
    return feat

def get_filters():
    """
    Asks user to specify a city, month, and day to analyze.

    Returns:
        (str) city - name of the city to analyze
        (str) month - name of the month to filter by, or "all" to apply no month filter
        (str) day - name of the day of week to filter by, or "all" to apply no day filter
    """
    city = None
    month = None
    day = None
    print('Hello! Let\'s explore some US bikeshare data!')

    city = ask_input('city', CITIES)
    month = ask_input('month', MONTHS)
    day = ask_input('day',DAYS)

    print(' - -'*15)
    return city, month, day

    return city, month, weekday

def load_data(city, month, weekday):
    """Loads data for the specified city and filters by month and day if applicable.

    Args:
        (str) city - name of the city to analyze
        (str) month - name of the month to filter by, or "all" to apply no month filter
        (str) day - name of the day of week to filter by, or "all" to apply no day filter
    Returns:
        df - Pandas DataFrame containing city data filtered by month and day
    """
    df = pd.read_csv(CITY_DATA[city])

    # filter by month if applicable
    df['Start Time'] = pd.to_datetime(df['Start Time'])
    # extract month and day of week from Start Time to create new columns
    df['month'] =  pd.DatetimeIndex(df['Start Time']).month
    df['day_of_week'] = pd.DatetimeIndex(df['Start Time']).day
    # filter by month if applicable
    if month != 'all':
        # use the index of the months list to get the corresponding int
        month = MONTHS.index(month) + 1
        # filter by month to create the new dataframe
        df = df[df['month'] == month]
    if weekday != 'all':
        # use the index of the months list to get the corresponding int
        weekday = DAYS.index(weekday) + 1
        # filter by month to create the new dataframe
        df = df[df['day_of_week'] == weekday]
    return df


def time_stats(df):

    """Displays statistics on the most popular times and months."""

    print('\nCalculating The Most Frequent Times of Travel...\n')
    start_time = time.time()
    df['Start Time'].mode()

    ### TO DO: display the most common month
    print("\nMost common month is :\n{}".format(MONTHS[df['month'].mode()[0]-1]).title())
    # TO DO: display the most common day of week
    print("\nMost common day of week is :\n{}".format(MONTHS[df['month'].mode()[0]]).title())

    # TO DO: display the most common start hour
    df['hour'] = pd.DatetimeIndex(df['Start Time']).hour
    print("\nMost common start hour is : \n{}".format(df['hour'].mode()[0]))
    print("\nTime taken: {} seconds \n".format(time.time()-start_time))
    print(' - -'*15)


def station_stats(df):
    """Displays statistics on the most popular stations and trip."""

    print('\nCalculating The Most Popular Stations and Trip...\n')
    start_time = time.time()

    # TO DO: display most commonly used start station
    print("\nPopular start station is :\n{}".format(df['Start Station'].mode()[0]))
    # TO DO: display most commonly used end station
    print("\nPopular end station is :\n{} ".format(df['End Station'].mode()[0]))

    # TO DO: display most frequent combination of start station and end station trip
    po = df['Start Station'].mode()
    po2 = df['End Station'].mode()
    print("\nPopular stations are :\n",
    df.groupby(['Start Station','End Station']).size().idxmax())

    print("\nTime taken: {} seconds \n".format(time.time()-start_time))
    print(' - -'*15)


def trip_duration_stats(df):

    """Displays statistics on the total and average trip duration."""

    print('\nCalculating Trip Duration...\n')
    start_time = time.time()
    # TO DO: display total travel time
    print("\nTotal Display time in hours :\n{}".format(df['Trip Duration'].sum()))

    # TO DO: display mean travel time
    print("\nTotal mean Display time in hours: \n{}".format(round(df['Trip Duration'].mean(),6)))


    print("\nTime taken: {} seconds \n".format(time.time()-start_time))
    print(' - -'*15)



def user_stats(df,city):
    """Displays statistics on bikeshare users."""

    print('\nCalculating User Stats...\n')
    start_time = time.time()
    # TO DO: Display counts of user types
    print("\nCounts of user types :\n{} ".format(df['User Type'].value_counts()))
    # TO DO: Display counts of gender
    """not in CITY_DATA"""
    if city != 'washington':
        print("\nCounts of gender :\n{}".format(df['Gender'].value_counts()))
        # TO DO: Display earliest, most recent, and most common year of birth
        print("\nMost recent Year of Birth :\n{}".format(df['Birth Year'].max()))
        print("\nMost Common  Year of Birth :\n{} ".format(df['Birth Year'].mode()[0]))


    print("\nTime taken: {} seconds \n".format(time.time()-start_time))
    print(' - -'*15)

def user_prompt():
    """Asks for user input to view the dataframe and prompts if the input is not a leagal choice."""

    ans = None
    while ans not in CHOICES:
        ans = input("\nDo you want to see the next 5 data rows? (yes/no)\n").lower()
        if ans not in CHOICES:
            print("\nILLEGEL CHOICE...Please choose from yes/no\n")
    return ans


def _raw_data(df):
    """Displays the dataframes till the end as per user choice."""

    for i in range(0,len(df),5):
        ans = user_prompt()
        if ans in ['yes','y']:
            try:
                print(df.iloc[i:i+5,:])
            except Exception as e:
                print("\nEnd of the DATAFRAME\n")
        else:
            break

def main():
    while True:
        city, month, weekday = get_filters()
        df = load_data(city, month, weekday)
        df.info()
        df.describe()
        time_stats(df)
        station_stats(df)
        trip_duration_stats(df)
        user_stats(df,city)
        _raw_data(df)


        restart = input('\nWould you like to restart? Enter yes/no.\n').lower()
        if restart not in ['yes', 'y']:
            break

if __name__ == "__main__":
	main()
