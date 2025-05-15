# Hash Table Implementation with Linear Probing

## Design Overview

This implementation provides a generic hash table data structure using linear probing for collision resolution. The hash table is implemented as a template class to support any key-value pair types, making it highly versatile for different use cases.

### Core Components

1. **Entry Structure**
   ```cpp
   struct Entry {
       K key;
       V value;
       bool isOccupied;
       bool isDeleted;
   }
   ```
   - `isOccupied`: Indicates if the slot contains a value
   - `isDeleted`: Marks entries that have been deleted (tombstone)
   - This design allows for efficient handling of deletions in the probe chain

2. **Member Variables**
   - `std::vector<Entry> table`: The underlying storage
   - `size_t size`: Number of active elements
   - `size_t capacity`: Total table capacity
   - `const double LOAD_FACTOR_THRESHOLD`: Maximum load factor (0.7)

## Linear Probing Implementation

### Collision Resolution
Linear probing is implemented through a systematic approach:

1. **Initial Probe**
   - Calculate initial index using hash function: `hash(key) % capacity`

2. **Probe Sequence**
   ```cpp
   index = (index + 1) % capacity
   ```
   - When collision occurs, linearly probe to next position
   - Wrap around to start of table using modulo operation

3. **Search Process**
   - Continue probing until:
     - Finding an empty slot (for insertion)
     - Finding the target key (for lookup/deletion)
     - Returning to original position (table full)

### Handling Deletions
- Uses tombstone marking (`isDeleted` flag) instead of physical removal
- Maintains probe chain integrity for subsequent lookups
- Deleted entries can be reused for new insertions

## Dynamic Resizing and Load Factor Management

### Load Factor Monitoring
```cpp
double getLoadFactor() const { return (double)size / capacity; }
```
- Load factor = number of elements / table capacity
- Threshold set at 0.7 to balance between space usage and performance

### Resizing Process
1. **Trigger Condition**
   - Resize triggered when: `(size + 1) / capacity > 0.7`
   - Table capacity doubles when threshold exceeded

2. **Resize Operation**
   ```cpp
   void resize() {
       size_t oldCapacity = capacity;
       std::vector<Entry> oldTable = std::move(table);
       capacity *= 2;
       table.resize(capacity);
       size = 0;
       // Rehash existing elements
   }
   ```

3. **Rehashing**
   - All non-deleted elements from old table are reinserted
   - New positions calculated using updated capacity
   - Maintains proper probe chains in new table

## Performance Characteristics

### Time Complexity
- Average case:
  - Insert: O(1)
  - Delete: O(1)
  - Get: O(1)
- Worst case (when table is nearly full):
  - All operations: O(n)

### Space Complexity
- O(n) where n is the capacity of the table
- Extra space used during resizing: O(n)

### Load Factor Impact
- Higher load factor increases collision probability
- 0.7 threshold provides good balance between:
  - Memory utilization
  - Performance degradation
  - Frequency of resizing operations

## Usage Example

```cpp
HashTable<std::string, int> ht;
ht.insert("key1", 100);
ht.insert("key2", 200);

auto value = ht.get("key1");  // Returns std::optional<int>
if (value.has_value()) {
    std::cout << value.value();  // Prints 100
}

ht.delete_key("key1");  // Removes key1
```

## Implementation Decisions and Trade-offs

1. **Template Design**
   - Pros: Type flexibility, reusability
   - Cons: Code bloat for multiple instantiations

2. **Linear Probing**
   - Pros: Cache-friendly, simple implementation
   - Cons: Susceptible to clustering

3. **Load Factor Choice (0.7)**
   - Pros: Good balance of space/time
   - Cons: May resize more frequently than higher thresholds

4. **Tombstone Deletion**
   - Pros: Maintains probe chain integrity
   - Cons: Space overhead for deleted entries
