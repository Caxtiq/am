package com.example.amzinlibapp.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.amzinlibapp.model.Borrow;
import com.example.amzinlibapp.model.User;


@Repository
public interface BorrowRepository extends JpaRepository<Borrow, Long> {
    List<Borrow> findAllByUser(User user);
    List<Borrow> findAllByUserId(Long userId);
}