#include <iostream>
#include <vector>
#include <optional>
#include <stdexcept>

template<typename K, typename V>
class HashTable {
private:
    struct Entry {
        K key;
        V value;
        bool isOccupied;
        bool isDeleted;
        
        Entry() : isOccupied(false), isDeleted(false) {}
    };
    
    std::vector<Entry> table;
    size_t size;
    size_t capacity;
    const double LOAD_FACTOR_THRESHOLD = 0.7;
    
    size_t hash(const K& key) const {
        return std::hash<K>{}(key) % capacity;
    }
    
    size_t findPosition(const K& key) const {
        size_t index = hash(key);
        size_t originalIndex = index;
        
        do {
            if (!table[index].isOccupied || 
                (!table[index].isDeleted && table[index].key == key)) {
                return index;
            }
            index = (index + 1) % capacity;
        } while (index != originalIndex);
        
        throw std::runtime_error("Hash table is full");
    }
    
    void resize() {
        size_t oldCapacity = capacity;
        std::vector<Entry> oldTable = std::move(table);
        
        capacity *= 2;
        table.resize(capacity);
        size = 0;
        
        for (size_t i = 0; i < oldCapacity; i++) {
            if (oldTable[i].isOccupied && !oldTable[i].isDeleted) {
                insert(oldTable[i].key, oldTable[i].value);
            }
        }
    }

public:
    HashTable(size_t initialCapacity = 16) 
        : capacity(initialCapacity), size(0) {
        table.resize(capacity);
    }
    
    void insert(const K& key, const V& value) {
        if ((double)(size + 1) / capacity > LOAD_FACTOR_THRESHOLD) {
            resize();
        }
        
        size_t index = findPosition(key);
        
        if (!table[index].isOccupied || table[index].isDeleted) {
            size++;
        }
        
        table[index].key = key;
        table[index].value = value;
        table[index].isOccupied = true;
        table[index].isDeleted = false;
    }
    
    bool delete_key(const K& key) {
        size_t index = hash(key);
        size_t originalIndex = index;
        
        do {
            if (!table[index].isOccupied) {
                return false;
            }
            
            if (!table[index].isDeleted && table[index].key == key) {
                table[index].isDeleted = true;
                size--;
                return true;
            }
            
            index = (index + 1) % capacity;
        } while (index != originalIndex);
        
        return false;
    }
    
    std::optional<V> get(const K& key) const {
        size_t index = hash(key);
        size_t originalIndex = index;
        
        do {
            if (!table[index].isOccupied) {
                return std::nullopt;
            }
            
            if (!table[index].isDeleted && table[index].key == key) {
                return table[index].value;
            }
            
            index = (index + 1) % capacity;
        } while (index != originalIndex);
        
        return std::nullopt;
    }
    
    void display() const {
        for (size_t i = 0; i < capacity; i++) {
            std::cout << "Index " << i << ": ";
            if (table[i].isOccupied && !table[i].isDeleted) {
                std::cout << "Key: " << table[i].key 
                         << ", Value: " << table[i].value;
            } else if (table[i].isDeleted) {
                std::cout << "DELETED";
            } else {
                std::cout << "EMPTY";
            }
            std::cout << std::endl;
        }
    }
    
    size_t getSize() const { return size; }
    size_t getCapacity() const { return capacity; }
    double getLoadFactor() const { return (double)size / capacity; }
};

// Example usage
int main() {
    HashTable<std::string, int> ht;
    
    // Insert some key-value pairs
    ht.insert("apple", 1);
    ht.insert("banana", 2);
    ht.insert("cherry", 3);
    ht.insert("date", 4);
    
    std::cout << "Initial hash table:" << std::endl;
    ht.display();
    std::cout << "\nSize: " << ht.getSize() 
              << ", Capacity: " << ht.getCapacity()
              << ", Load Factor: " << ht.getLoadFactor() << std::endl;
    
    // Test get operation
    auto value = ht.get("banana");
    if (value.has_value()) {
        std::cout << "\nValue for 'banana': " << value.value() << std::endl;
    }
    
    // Test delete operation
    ht.delete_key("cherry");
    std::cout << "\nAfter deleting 'cherry':" << std::endl;
    ht.display();
    
    // Test update operation
    ht.insert("apple", 10);  // Update existing key
    std::cout << "\nAfter updating 'apple':" << std::endl;
    ht.display();
    
    return 0;
}
