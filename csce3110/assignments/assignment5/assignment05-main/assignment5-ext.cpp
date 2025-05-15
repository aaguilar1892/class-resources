#include <iostream>
#include <string>
#include <vector>
#include <limits>

class HashTable {
private:
    struct Entry {
        std::string key;
        int value;
        bool isOccupied;
        bool isDeleted;
        
        Entry() : key(""), value(0), isOccupied(false), isDeleted(false) {}
    };
    
    std::vector<Entry> table;
    int size;
    int capacity;
    double loadFactor;
    
    int hash(const std::string& key) const {
        int hash = 0;
        for (char c : key) {
            hash = (hash * 31 + c) % capacity;
        }
        return hash;
    }
    
    void rehash(int newCapacity) {
        std::vector<Entry> oldTable = table;
        int oldCapacity = capacity;
        
        // Initialize new table
        capacity = newCapacity;
        size = 0;
        table = std::vector<Entry>(capacity);
        
        // Reinsert all entries
        for (const Entry& entry : oldTable) {
            if (entry.isOccupied && !entry.isDeleted) {
                insert(entry.key, entry.value);
            }
        }
        std::cout << "Hash table resized from " << oldCapacity << " to " << capacity << std::endl;
    }

public:
    HashTable(int initialCapacity = 5) 
        : capacity(initialCapacity), size(0), loadFactor(0.7) {
        table.resize(capacity);
    }
    
    void insert(const std::string& key, int value) {
        // Check if resize is needed
        if ((double)(size + 1) / capacity > loadFactor) {
            rehash(capacity * 2);
        }
        
        int index = hash(key);
        int originalIndex = index;
        bool found = false;
        
        // Linear probing
        do {
            if (!table[index].isOccupied || table[index].isDeleted) {
                // Found empty spot
                table[index].key = key;
                table[index].value = value;
                table[index].isOccupied = true;
                table[index].isDeleted = false;
                size++;
                found = true;
            } else if (table[index].key == key) {
                // Update existing key
                table[index].value = value;
                found = true;
            } else {
                // Try next spot
                index = (index + 1) % capacity;
            }
        } while (!found && index != originalIndex);
        
        if (!found) {
            std::cout << "Error: Hash table is full" << std::endl;
        }
    }
    
    bool get(const std::string& key, int& value) {
        int index = hash(key);
        int originalIndex = index;
        
        do {
            if (!table[index].isOccupied) {
                return false;
            }
            if (table[index].isOccupied && !table[index].isDeleted && 
                table[index].key == key) {
                value = table[index].value;
                return true;
            }
            index = (index + 1) % capacity;
        } while (index != originalIndex);
        
        return false;
    }
    
    bool remove(const std::string& key) {
        int index = hash(key);
        int originalIndex = index;
        
        do {
            if (!table[index].isOccupied) {
                return false;
            }
            if (table[index].isOccupied && !table[index].isDeleted && 
                table[index].key == key) {
                table[index].isDeleted = true;
                size--;
                return true;
            }
            index = (index + 1) % capacity;
        } while (index != originalIndex);
        
        return false;
    }
    
    void display() const {
        std::cout << "\nHash Table Contents (Capacity: " << capacity << "):" << std::endl;
        std::cout << "Current size: " << size << " elements" << std::endl;
        std::cout << "Current load factor: " << (double)size / capacity << std::endl;
        std::cout << "---------------------------" << std::endl;
        
        for (int i = 0; i < capacity; i++) {
            std::cout << "Index " << i << ": ";
            if (table[i].isOccupied && !table[i].isDeleted) {
                std::cout << table[i].key << " -> " << table[i].value;
            } else if (table[i].isDeleted) {
                std::cout << "DELETED";
            } else {
                std::cout << "None";
            }
            std::cout << std::endl;
        }
        std::cout << "---------------------------" << std::endl;
    }
};

void clearInputBuffer() {
    std::cin.clear();
    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
}

void displayMenu() {
    std::cout << "\nHash Table Operations:" << std::endl;
    std::cout << "1. Insert key-value pair" << std::endl;
    std::cout << "2. Get value by key" << std::endl;
    std::cout << "3. Delete key" << std::endl;
    std::cout << "4. Display hash table" << std::endl;
    std::cout << "5. Exit" << std::endl;
    std::cout << "Enter your choice (1-5): ";
}

int main() {
    int initialCapacity;
    std::cout << "Enter initial hash table capacity: ";
    std::cin >> initialCapacity;
    
    HashTable ht(initialCapacity);
    std::cout << "Hash table created with capacity " << initialCapacity << std::endl;
    
    while (true) {
        displayMenu();
        
        int choice;
        std::cin >> choice;
        clearInputBuffer();
        
        if (choice == 5) {
            std::cout << "Exiting program." << std::endl;
            break;
        }
        
        switch (choice) {
            case 1: {
                std::string key;
                int value;
                std::cout << "Enter key: ";
                std::getline(std::cin, key);
                std::cout << "Enter value: ";
                std::cin >> value;
                clearInputBuffer();
                
                ht.insert(key, value);
                std::cout << "Inserted " << key << " -> " << value << std::endl;
                break;
            }
            case 2: {
                std::string key;
                std::cout << "Enter key to search: ";
                std::getline(std::cin, key);
                
                int value;
                if (ht.get(key, value)) {
                    std::cout << "Value found: " << key << " -> " << value << std::endl;
                } else {
                    std::cout << "Key not found: " << key << std::endl;
                }
                break;
            }
            case 3: {
                std::string key;
                std::cout << "Enter key to delete: ";
                std::getline(std::cin, key);
                
                if (ht.remove(key)) {
                    std::cout << "Successfully deleted key: " << key << std::endl;
                } else {
                    std::cout << "Key not found: " << key << std::endl;
                }
                break;
            }
            case 4: {
                ht.display();
                break;
            }
            default: {
                std::cout << "Invalid choice. Please try again." << std::endl;
                break;
            }
        }
    }
    
    return 0;
}