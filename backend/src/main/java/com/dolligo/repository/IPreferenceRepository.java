package com.dolligo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dolligo.dto.Preference;

@Repository
public interface IPreferenceRepository extends JpaRepository<Preference, Integer>{
}
