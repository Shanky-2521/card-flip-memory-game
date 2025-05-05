# Vivado Build Script for Card Flip Memory Game

# Project Settings
set project_name "card_flip_memory_game"
set project_dir "./build"
set part_number "xc7a35tcpg236-1"  # Example for Artix-7 board, adjust as needed

# Create Project
file mkdir $project_dir
create_project $project_name $project_dir -part $part_number -force

# Set project properties
set_property target_language Verilog [current_project]

# Add source files
add_files -norecurse [glob ./src/rtl/*.v]
add_files -norecurse ./constraints/card_flip_game.xdc

# Add simulation files
add_files -fileset sim_1 [glob ./src/testbench/*.v]

# Set top-level module
set_property top card_flip_game_top [current_fileset]
set_property top_file "./src/rtl/card_flip_game_top.v" [current_fileset]

# Run synthesis
launch_runs synth_1
wait_on_run synth_1

# Run implementation
launch_runs impl_1
wait_on_run impl_1

# Generate bitstream
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

# Optional: Export hardware for SDK/Vitis
write_hw_platform -fixed -force -file "$project_dir/${project_name}_wrapper.xsa"

# Close project
close_project

puts "Build completed successfully!"
