# Basic Network Demo




features:

dynamically resizing tableview cells: 

set tableview in viewDidLoad():

tableView.rowHeight = UITableView.automaticDimension
tableView.estimatedRowHeight = 400

and set the subview of a cell's content view to have intrinsic size, probably leading/trailing/top/bottom. 

for instance, a subview can be a UILabel, which can have 0 lines - i.e have its text determine its intrinsic size. 


This should be enough to tell the tableview cell to resize according to the intrinsic size of the content view 



coding keys that rename JSON properties

codable protocol for decoding JSON response