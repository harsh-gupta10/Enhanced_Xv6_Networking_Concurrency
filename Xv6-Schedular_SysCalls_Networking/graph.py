import matplotlib.pyplot as plt

# Sample data (replace this with your actual data)
data = [
    ("P1", 0, 0),
    ("P2", 0, 0),
    ("P3", 0, 0),
    ("P4", 0, 0),
    ("P5", 0, 0),
    ("P1", 1, 113), 
    ("P1",0,137),
    ("P1",1,161),
    ("P2",1,77),
    ("P2",0,113),
    ("P2",1,120),
    ("P2",0,193),
    ("P2",1,209),
    ("P3",1,77),
    ("P3",1,209),
    ("P4",1,77),
    ("P4",0,120),
    ("P4",1,126),
    ("P4",0,175),
    ("P4",2,193), 
    ("P5",1,77),
    ("P5",0,126),
    ("P5",1,132),
    ("P5",2,161),
    ("P5",2,175),
]

# Create a color map for processes
process_colors = {"P1": 'red', "P2": 'green', "P3": 'blue', "P4": 'purple', "P5": 'orange'}

# Create a timeline plot without points
plt.figure(figsize=(10, 6))

# Store the previous point for each process
previous_points = {}

# Iterate through the data and plot lines for each process at a given time and queue
for process_name, queue_id, time in data:
    if process_name not in previous_points:
        # If this is the first point for the process, just record it
        previous_points[process_name] = (time, queue_id)
    else:
        # If this is not the first point for the process, plot a line from the previous point
        prev_time, prev_queue_id = previous_points[process_name]

        # Check if queue ID has changed for the process
        if prev_queue_id != queue_id:
            # Create a solid vertical line between transitions
            plt.plot([prev_time, prev_time], [prev_queue_id, queue_id], color=process_colors[process_name], linewidth=2)
            # Create a horizontal line to the new queue
            plt.plot([prev_time, time], [queue_id, queue_id], color=process_colors[process_name], linewidth=2)
        else:
            # Regular line with a slope
            plt.plot([prev_time, time], [prev_queue_id, queue_id], color=process_colors[process_name], linewidth=2)

        previous_points[process_name] = (time, queue_id)

# Customize the plot
plt.title('MLFQ Scheduler Timeline')
plt.xlabel('Number of Ticks')
plt.ylabel('Queue ID')
plt.yticks(range(max([queue_id for (_, queue_id, _) in data]) + 1), [f'Queue {i}' for i in range(max([queue_id for (_, queue_id, _) in data]) + 1)])
plt.grid()

# Create a legend for process colors
legend_handles = [plt.Line2D([0], [0], color=color, label=process_name, linewidth=2) for process_name, color in process_colors.items()]
plt.legend(handles=legend_handles, loc='upper left')

# Show the plot
plt.show()
