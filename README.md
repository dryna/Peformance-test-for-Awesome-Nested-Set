#Performance Tests Awesome Nested Set

Source flies and project is from https://github.com/collectiveidea/awesome_nested_set

#full_binary_tree_all_times_spec.rb
graph:
```
     (1)
    /   \
  (2)   (3)
  / \   / \
 (4)(5)(6)(7)
      .
      .
      .
()    ...    (n)
```
where n = 2^k -1 where k is natural number > 0

It measures:
- wall time
- process time
- cpu time
- allocations
- memory (only working with proper patched ruby version see https://github.com/ruby-prof/ruby-prof )

For operation:
-add_descendant
-remove
-ancestors
-roots
all results will be saved in tmp folder as xls files

To change size of graph change variable at the beginning of test file @n

#full_binary_tree_spec.rb
graph:
```
     (1)
    /   \
  (2)   (3)
  / \   / \
 (4)(5)(6)(7)
      .
      .
      .
()    ...    (n)
```
where n = 2^k -1 where k is natural number > 0

It measures:
- wall time
- process time

For operation:
- add_descendant
- remove
- ancestors
- roots

all results will be saved in tmp folder as different xls files
for every operation there will be 20 measurements done

To change size of graph change variable at the beginning of test file @n

#full_binary_tree_fast_seed_spec.rb
graph:
```
     (1)
    /   \
  (2)   (3)
  / \   / \
 (4)(5)(6)(7)
      .
      .
      .
()    ...    (n)
```
where n = 2^k -1 where k is natural number > 0

It measures:
- wall time
- process time

For operation:
- remove
- ancestors
- roots

all results will be saved in tmp folder as different xls files
for every operation there will be 20 measurements done

To change size of graph change variable at the beginning of test file @n

Graph is build with one insert to database.
Use this graph for fast results. Building tree by adding nodes to database with use of children.create or by moving nodes
takes a lot of time, by using one insert we seed database much faster.

#nodes_in_line_spec.rb
```
(1)
 |
(2)
 .
 .
 .
(n)
```
It measures:
- wall time
- process time

For operation:
- add_descendant
- remove
- ancestors
- roots
all results will be saved in tmp folder as different xls files
for every operation there will be 20 measurements done

#nodes_in_line_all_times_spec.rb
```
(1)
 |
(2)
 .
 .
 .
(n)
```
It measures:
- wall time
- process time
- cpu time
- allocations
- memory (only working with proper patched ruby version see https://github.com/ruby-prof/ruby-prof )

For operation:
- add_descendant
- remove
- ancestors
- roots
all results will be saved in tmp folder as xls files

#nodes_in_line_fast_seed_spec.rb
```
(1)
 |
(2)
 .
 .
 .
(n)
```
It measures:
- wall time
- process time

For operation:
- remove
- ancestors
- roots
all results will be saved in tmp folder as different xls files
for every operation there will be 20 measurements done

Graph is build with one insert to database.
Use this graph for fast results. Building tree by adding nodes to database with use of children.create or by moving nodes
takes a lot of time, by using one insert we seed database much faster

#one_root_rest_children_fast_seed_spec.rb
```
    (1)
   / | \
 (2)...(n)
```
It measures:
- wall time
- process time

For operation:
- remove
- ancestors
- roots

all results will be saved in tmp folder as different xls files
for every operation there will be 20 measurements done

Graph is build with one insert to database.
Use this graph for fast results. Building tree by adding nodes to database with use of children.create or by moving nodes
takes a lot of time, by using one insert we seed database much faster

#one_root_rest_children_spec.rb
```
    (1)
   / | \
 (2)...(n)
```
It measures:
- wall time
- process time

For operation:
- add_descendant
- remove
- ancestors
- roots

all results will be saved in tmp folder as different xls files
for every operation there will be 20 measurements done

#total_performance_spec.rb
It measures:
- wall time
- process time
for all graphs mention above

For operations:
- each_with_level -measuring time to get whole tree
- destroy -measuring time taken to remove last node from the graph
- ancestors -measuring time taken to read ancestor
  - from last node
  - form middle of the graph @n/2
- descendants -measuring time taken to read ancestor
  - from first node
  - form middle of the graph @n/2
- root -measuring time take to get roots from last node in the graph

all results will be saved in tmp folder as one xls files
for every operation there will be 10 measurements done