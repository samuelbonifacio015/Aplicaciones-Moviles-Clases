package com.example.semana5_sqlite.view

import android.content.Context
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountCircle
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material3.Card
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavHostController
import com.example.semana5_sqlite.viewmodel.viewModelUser

@Composable
fun ListUser(viewModel: viewModelUser,
             context: Context,
             recordarPantalla: NavHostController) {
    val listUsers = viewModel.listUsers

    LaunchedEffect(Unit) {
        viewModel.listUserAll(context)
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(20.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text("Lista de Usuarios",
            fontSize = 25.sp,
            fontWeight = FontWeight.Bold,
            textAlign = TextAlign.Center
        )
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
        ) {
            items(listUsers) { user ->
                Card(
                    onClick = {},
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(10.dp)
                        .heightIn(min = 100.dp)
                ) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.Center,
                        modifier = Modifier
                            .fillMaxSize()
                            .padding(5.dp)
                    ) {
                        Icon(
                            Icons.Default.AccountCircle,
                            contentDescription = null,
                            modifier = Modifier.size(50.dp)
                        )

                        Column(
                            modifier = Modifier
                                .padding(horizontal = 5.dp)
                                .width(210.dp)
                        ) {
                            Text(text = "${user.id}")
                            Text(text = user.name)
                            Text(text = "${user.age}")
                            Text(text = user.email)
                        }

                        IconButton(
                            onClick = {
                                viewModel.deleteUser(context, user.id)
                            }
                        ) {
                            Icon(Icons.Default.Delete,
                                contentDescription = "Eliminar")
                        }

                        IconButton(
                            onClick = {
                                viewModel.selectUser(user)
                                recordarPantalla.navigate("Home")
                            }
                        ) {
                            Icon(Icons.Default.Edit,
                                contentDescription = "Editar")
                        }
                    }
                }
            }
        }
    }
}
