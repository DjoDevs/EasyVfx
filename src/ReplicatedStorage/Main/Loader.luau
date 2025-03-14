repeat 
    task.wait()
until game:IsLoaded()

require(script.Parent.ClientEffects)
require(script.Parent.CollectionService)

return nil