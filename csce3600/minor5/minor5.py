# Author: Alexis Aguilar
# Course: CSCE 3600.004
# Date: 12/02/2024
# Description: This program processes a data file to allow users to search for entries by city or zip code.

def load_records(filename):
    """
    Reads data from a tab-separated file and organizes it into two dictionaries:
    - A dictionary mapping zip codes to lists of records (tuples).
    - A dictionary mapping cities to sets of zip codes.
    """
    zip_to_records = {}
    city_to_zip = {}
    
    try:
        with open(filename, 'r') as file:
            for line in file:
                # Parse fields
                state, street_address, city, zip_code = line.strip().split('\t')
                record = (state, street_address, city, zip_code)
                
                # Update zip_to_records
                if zip_code not in zip_to_records:
                    zip_to_records[zip_code] = []
                zip_to_records[zip_code].append(record)
                
                # Update city_to_zip
                city_lower = city.lower()  # normalize to lowercase for case-insensitive search
                if city_lower not in city_to_zip:
                    city_to_zip[city_lower] = set()
                city_to_zip[city_lower].add(zip_code)
    except FileNotFoundError:
        print(f"Error: File '{filename}' not found.")
        return {}, {}
    except Exception as e:
        print(f"Error reading file: {e}")
        return {}, {}
    
    return zip_to_records, city_to_zip


def main():
    """
    Main function to interact with the user.
    Allows searching for records by city or zip code.
    """
    # Load data
    filename = "minor5.tsv"
    zip_to_records, city_to_zip = load_records(filename)
    
    if not zip_to_records or not city_to_zip:
        print("Failed to load records. Exiting.")
        return
    
    # User interaction loop
    while True:
        user_input = input("Enter input (city name, zip code, or 'quit' to exit): ").strip()
        
        if user_input.lower() == "quit":
            print("Exiting program.")
            break
        
        if user_input.isdigit():  # Search by zip code
            zip_code = user_input
            if zip_code in zip_to_records:
                for record in zip_to_records[zip_code]:
                    print(f"{record[1]}\n{record[2]}, {record[0]}, {record[3]}")
            else:
                print("No records found in this zip code.")
        else:  # Search by city
            city_lower = user_input.lower()
            if city_lower in city_to_zip:
                zip_codes = city_to_zip[city_lower]
                for zip_code in zip_codes:
                    for record in zip_to_records[zip_code]:
                        print(f"{record[1]}\n{record[2]}, {record[0]}, {record[3]}")
            else:
                print("No records found in this town.")


if __name__ == "__main__":
    main()