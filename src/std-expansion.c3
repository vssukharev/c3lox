
module std::collections::list(<Type>);

macro void List.push_unique(&self, Type to_push) 
{
  if (@catch(self.index_of(to_push))) {
    self.push(to_push);
  }
}

