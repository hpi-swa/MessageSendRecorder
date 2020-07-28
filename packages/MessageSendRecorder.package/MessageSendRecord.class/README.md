This is a record of a sent message. It holds on to the compiled method and stores also a little bit information about the receiver. A recorded message send points to its parent record, which (indirectly represents the actual sender. Records can have children, which are the message sends that happened when evaluating the compiled method.

recorder	... recording context in which the record tree can be extended

id 				... identifying number of this record, local to the record tree
parent 		... record that represents the sender
children 	... records of sends that happened then evaluating the method

method	... compiled method that was called during this send
sendId 		... identifying number of the send, local to the method in the record tree

receiverClass	... class of the message receiver
receiverId		... identifying number of the receiver, local to the record tree

extension		... additional information about this send, maybe expensive to hold on for too long ;-)