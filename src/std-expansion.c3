
module std::collections::list(<Type>);


/**
 * @param val
 *
 * @require types::is_equatable_type(Type) "Can't push unique value if it can't be compared"
 *
 * @return "Index of pushed or already present value"
 */
macro usz List.push_unique(&self, Type val) 
{
  usz! i = self.index_of(val);
  
  if (catch i) {
    self.push(val);
    return self.len() - 1;
  } else {
    return i;
  }
}

