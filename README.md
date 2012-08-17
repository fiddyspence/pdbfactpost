A function to post fact data into PuppetDB

    $moo = pdbfactpost('ceph_module_data',{'testfact' => 'some data','testfact2' => $keyring}) 
    notify { $moo: }
    $whatwejuststuffedin = pdbfactquery('ceph_module_data','testfact2')
    notify { $whatwejuststuffedin: }

What's currently missing, is some management around manipulating the data that comes
out of the PuppetDB afterwards.  The pdb query functions also need some massaging to 
get round the 404 errors that you get before the dummy node's facts exist.

