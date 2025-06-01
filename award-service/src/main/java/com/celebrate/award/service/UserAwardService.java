package com.celebrate.award.service;

import com.celebrate.award.dto.UserAwardDTO;
import com.celebrate.award.model.Award;
import com.celebrate.award.model.UserAward;
import com.celebrate.award.repository.AwardRepository;
import com.celebrate.award.repository.UserAwardRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class UserAwardService {
    private final UserAwardRepository userAwardRepository;
    private final AwardRepository awardRepository;
    private final AwardService awardService;

    public UserAwardService(UserAwardRepository userAwardRepository, 
                          AwardRepository awardRepository,
                          AwardService awardService) {
        this.userAwardRepository = userAwardRepository;
        this.awardRepository = awardRepository;
        this.awardService = awardService;
    }

    @Transactional(readOnly = true)
    public List<UserAwardDTO> getUserAwards(Long userId) {
        return userAwardRepository.findByUserId(userId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public UserAwardDTO getUserAwardById(Long id) {
        UserAward userAward = userAwardRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("User Award not found with id: " + id));
        return convertToDTO(userAward);
    }

    @Transactional
    public UserAwardDTO grantAward(UserAwardDTO userAwardDTO) {
        Award award = awardRepository.findById(userAwardDTO.getAwardId())
                .orElseThrow(() -> new EntityNotFoundException("Award not found with id: " + userAwardDTO.getAwardId()));

        UserAward userAward = convertToEntity(userAwardDTO);
        userAward.setAward(award);
        userAward = userAwardRepository.save(userAward);
        return convertToDTO(userAward);
    }

    @Transactional
    public void revokeAward(Long id) {
        if (!userAwardRepository.existsById(id)) {
            throw new EntityNotFoundException("User Award not found with id: " + id);
        }
        userAwardRepository.deleteById(id);
    }

    private UserAwardDTO convertToDTO(UserAward userAward) {
        UserAwardDTO dto = new UserAwardDTO();
        BeanUtils.copyProperties(userAward, dto, "award");
        dto.setAwardId(userAward.getAward().getId());
        dto.setAward(awardService.getAwardById(userAward.getAward().getId()));
        return dto;
    }

    private UserAward convertToEntity(UserAwardDTO dto) {
        UserAward userAward = new UserAward();
        BeanUtils.copyProperties(dto, dto, "id", "award", "awardedAt");
        return userAward;
    }
} 