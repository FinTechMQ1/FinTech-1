require 'torch'
require 'nn'
csv2t = require 'csv2tensor'
print '==> loading dataset'


if not opt then
   print '==> processing options'
   cmd = torch.CmdLine()
   cmd:text()
   cmd:text('SVHN Training/Optimization')
   cmd:text()
   cmd:text('Options:')
   cmd:option('-trainD', '../Data/Train_1989-1999.csv', 'Train dataset directory+file')
   cmd:option('-trainP', '../Data/Train_Pred_1989-1999.csv', 'Train predictions')
   cmd:option('-validD', '../Data/Valid_2000-2004.csv', 'Valid dataset directory+file')
   cmd:option('-validP', '../Data/Valid_Pred_2000-2004.csv', 'Valid Predictions')
   cmd:option('-instr', 'ssi', 'Instrument')
   cmd:option('-window', 10, 'Window Size')
   cmd:text()
   opt = cmd:parse(arg or {})
end

train_tensor, cols1 = csv2t.load('../Data/' .. opt.instr .. '/' .. opt.trainD .. opt.instr .. '.csv' , {exclude='date'})
--train_tensor, cols1 = csv2t.load('../Data/' .. 'all' .. '/' .. opt.trainD .. 'all' .. '.csv' , {exclude='date'})
valid_tensor, cols2 = csv2t.load('../Data/' .. opt.instr .. '/' .. opt.validD .. opt.instr .. '.csv', {exclude='date'})
win = opt.window*20
train_in = train_tensor:narrow(2,1,win):clone()
valid_in = valid_tensor:narrow(2,1,win):clone()
print(train_in[1])

train_tensors, cols1 = csv2t.load('../Data/' .. opt.instr .. '/' .. opt.trainP .. opt.instr .. '.csv')
--train_tensors, cols1 = csv2t.load('../Data/' .. 'all' .. '/' .. opt.trainP .. 'all' .. '.csv')
valid_tensors, cols2 = csv2t.load('../Data/' .. opt.instr .. '/' .. opt.validP .. opt.instr .. '.csv')

train_out = train_tensors:narrow(2,2,1):clone()
valid_out = valid_tensors:narrow(2,2,1):clone()

print(train_out[1])
assert(train_in:size()[2] == valid_in:size()[2], "Datasets have equal columns")


train_dataset = {}
for i=1,train_tensor:size()[1] do
	train_dataset[i] = {train_in[i],train_out[i]}
end

valid_dataset = {}
for i=1,valid_tensor:size()[1] do
	valid_dataset[i] = {valid_in[i],valid_out[i]}
end







