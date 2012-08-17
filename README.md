A function to post fact data into PuppetDB

    $thehash = {'testfact' => 'some data','testfact2' => $keyring}
    $wegetauuid = pdbfactpost('testhost9',$thehash)
    $factquery = pdbfactquery('testhost9','testfact')
    $newhash = edithash($thehash,'testfact','different data')
    $moo2 = pdbfactpost('testhost9',$newhash)
    $newdata = pdbfactquery('testhost9','testfact')

    notify { "initial fact post returns a uuid: ${wegetauuid}": } ->
    notify { "we then get that data out of the puppetdb ${factquery}": } ->
    notify { "and then we check for the new data ${newdata}": }

The pdb query functions also need some massaging to 
get round the 404 errors that you get before the dummy node's facts exist.

