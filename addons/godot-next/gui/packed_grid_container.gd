extends VBoxContainer
class_name PackedGridContainer
#Spill container

var hbox_index = [] #Array of all the HBox children
var cur_hbox #The hbox we're currently sending children into


func _ready():
	pass
	#create_hbox()

func create_hbox():
	var hbox = HBoxContainer.new()
	add_child(hbox)
	hbox_index.append(hbox) #Add it to our array
	cur_hbox = hbox_index.size()-1

func sort_children():

	var but_size = {} #Dictionary holding button as key, and its with as value
	create_hbox() #Create the initial hbox

	var cum_size = 0 #Cumulative size of all the buttons
	var x_size = rect_size.x #Max width the buttons can extend to
	var but_sep = 4 #By default hbox uses a separation of 4
	
	for i in get_children():
		
		if i.get_class() == "Button": #Make sure we're only selecting buttons
			remove_child(i)
			hbox_index[cur_hbox].add_child(i) #Reparent to initial hbox
	
	yield(get_tree(), "idle_frame") #Allow buttons to resize properly
	
	for i in hbox_index[cur_hbox].get_children():
		but_size[i] = i.rect_size.x #Get button size
	
	for i in hbox_index[cur_hbox].get_children(): #Reparent buttons back to us
		hbox_index[cur_hbox].remove_child(i)
		add_child(i)
	
	for i in but_size.keys(): #Using the dictionary of buttons, parent buttons to appropriate hbox
		if (cum_size + but_size[i] + but_sep) <= x_size: #Check if next button exceeds max width
			remove_child(i)
			hbox_index[cur_hbox].add_child(i)
			cum_size += but_size[i] + but_sep
			#print(str(cum_size)+" "+str(cur_hbox)+" "+ str(i.text))
		else: #Next button does exceed max width, move it to a new row
			#print("reparenting-"+str(cum_size+but_size[i] + 4))
			cum_size = but_size[i] + but_sep
			#print(str(cum_size)+" "+str(cur_hbox)+" "+ str(i.text))
			remove_child(i)
			create_hbox() #Create new hbox
			hbox_index[cur_hbox].add_child(i) #Reparent button to new hbox

	hbox_index = [] #Reset for use next time
