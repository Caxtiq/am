package com.example.amzinlibapp.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.amzinlibapp.model.Borrow;
import com.example.amzinlibapp.service.BorrowService;

@RestController
@RequestMapping("/api/borrows")
public class BorrowController {
    @Autowired
    private BorrowService borrowService;

    @GetMapping()
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<List<Borrow>> getAllBorrows() {
        List<Borrow> borrows = borrowService.getAllBorrows();
        System.out.println("all rqs: " + borrows);
        return ResponseEntity.ok(borrows);
    }

    @GetMapping("/user/{id}")
    public ResponseEntity<List<Borrow>> getBorrowsByUserId(@PathVariable Long id) {
        List<Borrow> borrows = borrowService.getBorrowsByUser(id);
        return ResponseEntity.ok(borrows);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Borrow> getBorrowById(@PathVariable Long id) {
        Optional<Borrow> borrow = borrowService.getBorrowById(id);
        return borrow.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Borrow> saveBorrow(@RequestBody Borrow borrow) {
        Borrow savedBorrow = borrowService.saveBorrow(borrow);
        return ResponseEntity.ok(savedBorrow);
    }

    @PutMapping()
    public ResponseEntity<Borrow> updateBorrowState(@RequestBody Borrow borrow) {
        Borrow savedBorrow = borrowService.getBorrowById(borrow.getId()).get();
        borrowService.deleteBorrow(borrow.getId());
        savedBorrow.setState(borrow.getState());
        borrowService.saveBorrow(borrow);
        return ResponseEntity.ok(savedBorrow);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteBorrow(@PathVariable Long id) {
        borrowService.deleteBorrow(id);
        return ResponseEntity.noContent().build();
    }
}