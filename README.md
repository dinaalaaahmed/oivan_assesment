# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Regarding choosing the encoding / decoding algorithm
** i needed to us db for two purpose when restarting the server, we should be able to decode old urls per requirement
** i wanted to save the hash in the database, so i can use a random hash function to overcome collision problem
** i used locks and transaction while running the encode query so that if two transactions where trying to add the same hash to two different urls, it would fail and rollback Due to uniqness on indices
** also i want the hash key to be index friendly so it's fast to search for a hash in the table


