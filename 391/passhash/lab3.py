#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import hashlib

def hash_to_int(hash_list):
    """
        The first part of the assignment is relatively straightforward: You
        should write a program that finds the password given its sha256 hash,
        assuming that the password is a number between 1 and 500000.
        input: a list of strings, each string is sha256 hash of an intger
        output: a list of integers

        example test case:
        hash_to_int(["6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b"
                    "d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35"])
                    -> [1, 2]
    """
    N = 500000
    j = 1
    hashes = {} # Keep a dictionary of (hash, val) combinations seen so far 
                # to avoid repeated iterations
    out = []
    for hash in hash_list:
        val = hashes.get(hash) # Check if the hash is in the dictionary, 
        if val:                # just append the val if so
            out.append(val)
        else:
            for i in range(j,N+1): # Otherwise continue checking numbers not checked previously
                h = hashlib.sha256(bytes(str(i).encode())).hexdigest()
                hashes[h] = i
                if h == hash:
                    j = i
                    out.append(i)
                    break
    return out


def salted_hahes_to_int(hash_list):
    """
        You should write a program that finds the password given it's salted
        sha256 hash, assuming that the password is a number between 1 and 500000

        input: a list of tuples of size 2, where the first element is a string salt 
        and the second element is a string hash.
        output: a list of integers

        example test case:
        salted_hahes_to_int([("salt", "dc90cf07de907ccc64636ceddb38e552a1a0d984743b1f36a447b73877012c39")
                     ("salt2","6626e0d24e096d7af41b2c4d3c56335f6c451c3ef26bde0b7d4343318b3bafc2")])
                    -> [1, 2]
    """
    N = 500000
    out = []
    for tup in hash_list: # Simply brute force, since hash table becomes unhelpful due to different keys
        salt = tup[0]
        hash = tup[1]
        for i in range(1,N+1):
            h = hashlib.sha256(bytes((salt + str(i)).encode())).hexdigest()
            if h == hash:
                out.append(i)
                break
    return out



def hard_salted_hashes_to_int(hash_list):
    
    def slow_hash(string):
        final_hash = hashlib.sha256(string.encode()).hexdigest()
        for i in range(0, 50):
            final_hash = hashlib.sha256(final_hash.encode()).hexdigest()
        return final_hash
    """
        you should write a program that finds the password given it's hash
        where the hash function used is "slow_hash" defined above,
        assuming that the password is a number between 1 and 500000.

        input: a list of tuples of size 2, where the first element is a small string
        salt and the second element is a string hash.
        output: a list of integers

        example test case:
        hash_to_int([("1", "4008ad2982764d814d13c952b703c4d741985fb00e3f2a929a6666ceb9df6f5a")
                     ("2","e9dc28d0778cc6be950ecd48b38d9e9bcec125ee9ef1ec96b0e5055a1f6e379a")])
                    -> [1, 2]
    """
    N = 500000
    j = 1
    hashes = {}
    h_list = sorted(list(enumerate(hash_list)), key = lambda x: x[1][0]) # Sort entries by salt, maintaining initial index
    s = h_list[0][0] # Consider lowest salts first (likely "0")
    out = []
    for tup in h_list:
        salt = tup[1][0]
        hash = tup[1][1]
        if salt != s:  # If the salt value is new, restart hash table from scratch for new salt
            s = salt
            j = 1
            hashes = {}
        val = hashes.get(hash)
        if val:
            out.append((tup[0], val[1])) # Append to out with initial index
        else:
            for i in range(j,N+1):
                h = slow_hash(salt + str(i))
                hashes[h] = (salt, i)
                if h == hash:
                    j = i
                    out.append((tup[0], i))
                    break
    out = [i[1] for i in sorted(out, key = lambda x: x[0])] # Put into initial order
    return out

