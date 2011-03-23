function toggleImportant(id)
{
  if ($(id).hasClassName('important'))
  {
    //console.log('is important, should change to not important');
    $(id).removeClassName('important');
    $(id).select('.important img').first().src = RJC_BULLET;
  }
  else
  {
    //console.log('is not important, should change to important');
    $(id).addClassName('important');
    $(id).select('.important img').first().src = RJC_FLAG;
  }
}