package [=PackageName].domain.Flowable.Memberships;

import java.util.List;

public interface IActIdMembershipManager {
void create(ActIdMembershipEntity actIdMembership);

List<ActIdMembershipEntity> findAllByUserId(String id);

    void delete(ActIdMembershipEntity actIdMembership);
    ActIdMembershipEntity findByUserGroupId(String userId, String groupId);

    List<ActIdMembershipEntity> findAllByGroupId(String oldRoleName);
        void deleteAll();
        }
