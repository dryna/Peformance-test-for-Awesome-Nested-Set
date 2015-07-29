#!/bin/bash
touch tmp/report_add_ancestor.xls
touch tmp/report_remove_from_bottom.xls
touch tmp/report_read_ancestors.xls
touch tmp/report_get_roots.xls

touch tmp/report_add_ancestor_process_time.xls
touch tmp/report_remove_from_bottom_process_time.xls
touch tmp/report_read_ancestors_process_time.xls
touch tmp/report_get_roots_process_time.xls

touch tmp/report_add_ancestor_cpu_time.xls
touch tmp/report_remove_from_bottom_cpu_time.xls
touch tmp/report_read_ancestors_cpu_time.xls
touch tmp/report_get_roots_cpu_time.xls

touch tmp/report_add_ancestor_allocations.xls
touch tmp/report_remove_from_bottom_allocations.xls
touch tmp/report_read_ancestors_allocations.xls
touch tmp/report_get_roots_allocations.xls

touch tmp/report_add_ancestor_memory.xls
touch tmp/report_remove_from_bottom_memory.xls
touch tmp/report_read_ancestors_memory.xls
touch tmp/report_get_roots_memory.xls

#for i in `seq 1 10`; do
#rspec spec/performance/awesome_nested_set_spec.rb
#rspec spec/performance/awesome_full_binary_tree_spec.rb
rspec spec/performance/awesome_nested_set_1000000_in_line_spec.rb
#rake spec SPEC=spec/performance/awesome_nested_set_1000000_in_line_spec.rb \ DB='postgresql'
#sleep 5
#done
