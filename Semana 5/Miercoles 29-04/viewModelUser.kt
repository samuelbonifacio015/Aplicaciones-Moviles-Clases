package com.example.semana5_sqlite.viewmodel

import android.content.Context
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import com.example.semana5_sqlite.model.User
import com.example.semana5_sqlite.model.db.OpenHelper


class viewModelUser(): ViewModel(){

    var listUsers: MutableList<User> by mutableStateOf(mutableListOf())
        private set

    var selectedUser: User? by mutableStateOf(null)
        private set

    fun insertUsere(context: Context, user: User){
        val dbHelper= OpenHelper(context)
        dbHelper.newUser(user)
        listUserAll(context)
    }

    fun listUserAll(context: Context){
        val dbHelper= OpenHelper(context)
        listUsers = dbHelper.readUser()
    }

    fun deleteUser(context: Context, id: Int){
        val dbHelper= OpenHelper(context)
        dbHelper.deleteUser(id)
        listUserAll(context)
    }

    fun updateUser(context: Context, user: User){
        val dbHelper= OpenHelper(context)
        dbHelper.updateUser(user)
        selectedUser = null
        listUserAll(context)
    }

    fun selectUser(user: User){
        selectedUser = user
    }

    fun clearSelectedUser(){
        selectedUser = null
    }

}
