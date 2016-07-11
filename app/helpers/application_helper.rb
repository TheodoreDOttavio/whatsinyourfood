module ApplicationHelper
  def removecommas mytext
    mysample = mytext.split(",")
    myreturn = mysample.pop
    return myreturn.to_s + " " + mysample.join(",")
  end
end
