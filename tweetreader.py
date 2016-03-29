
# coding: utf-8

# In[2]:

import json
import unicodecsv as csv
import unicodedata
import codecs


# In[8]:

class TweetReader:
    """
    Utility class providing conversation of our dumbly formatted
    files containing scraped tweets into python dictionaries
    sequententially, which can then be easily applied to clean and output 
    to a file.
    """
    def __init__(self, infile, outfile):
        self.infile_str = infile
        self.outfile_str = outfile
        self.infile = codecs.open(infile, 'r', encoding='utf-8')
        self.line_count = 0
        self.base = ""
        
        if not self.outfile_str is None:
            self.outfile = open(outfile, 'w')
        else:
            self.outfile = None
    
    def init_outfile(self, outfile_str):
        if not self.outfile is None and self.outfile_str is None:
            raise Exception('Use update method to update Reader outfile.')
        
        self.outfile_str = outfile_str
        self.outfile = open(self.outfile_str, 'w')
        return True
    
    def update_outfile(self, outfile_str):
        if self.outfile is None or self.outfile_str is None:
            raise Exception('Use init method to initialize Reader outfile.')
        
        self.outfile_str = outfile_str
        self.outfile = open(self.outfile_str,'w')
              
    def __iter__(self):
        return self
    """
    Attempt to read an object from the input file. Malformed input file will cause an exception.
    """
    def next(self):
        def to_json(st):
            return json.loads(st)
        
        while True:
            try:
                line = next(self.infile)
                self.line_count += 1
                if self.line_count % 500000 == 0:
                    print "Hit 500000, total: {0}".format(self.line_count)
            except StopIteration:
                print "hit end of input file"
                try:
                    obj = to_json(self.base)
                    self.base = ""
                except:
                    raise StopIteration()
                
            if line.strip() == '}{':
                self.base += '}'
                try:
                    obj = json.loads(self.base)
                except Exception as e:
                    print line
                    print self.base
                    raise e
                self.base = '{'
                return obj
            else:
                self.base += line
    """
    Attempt to read an input JSON object, then apply the argument clean 
    """
    def read_and_clean(self, clean_function):
        obj = self.next()
        cleaned = clean_function(obj)
        return cleaned
    
    def write(self, obj):
        if self.outfile is None:
            raise Exception("Method requires outfile.")
            
        writer = csv.DictWriter(self.outfile, fieldnames=obj.keys())
        writer.writerow(obj)
        return True
    
    def clean_and_write(self, obj, clean):
        self.write(clean(obj))
        return True
    
    def clean_and_write_all(self,clean,count=None):
        c = 0
        error_count = 0
        for obj in self:
            if obj is None:
                continue
            else:
                c += 1
            self.clean_and_write(obj,clean)
            if not count is None:
                if c > count:
                    break
        print "Converted {0} tweets from source file {1}\
                 to output file {2}".format(c, self.infile_str, self.outfile_str)
        print "{0} write attempts failed".format(error_count)


