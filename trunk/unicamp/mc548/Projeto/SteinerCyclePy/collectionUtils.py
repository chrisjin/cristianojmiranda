#-- 
def findItemList(lst, item):
	try:
		return lst.index(item);
	except ValueError:
		return -1;

# -- Find Item in hash by key
def findHashItem(hs, key):
	try:
		hs[key];
		return 1;
	except KeyError:
		return 0;
