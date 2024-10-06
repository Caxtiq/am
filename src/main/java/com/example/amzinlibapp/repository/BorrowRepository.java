package com.example.amzinlibapp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.amzinlibapp.model.Borrow;

@Repository
public interface BorrowRepository extends JpaRepository<Borrow, Long> {
}