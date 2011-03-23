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

function toggleImportantInIssue(id)
{
  img = $(id).select('img').first()
  if (img.src.endsWith(RJC_FLAG))
  {
    //console.log('is important, should change to not important');
    img.src = RJC_BULLET;
  }
  else
  {
    //console.log('is not important, should change to important');
    img.src = RJC_FLAG;
  }
}