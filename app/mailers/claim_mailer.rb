class ClaimMailer < ApplicationMailer
    def claimed(claim)
        mail(
            to: claim.post.user.email,
            subject: "An user claimed post #{claim.post.number}"
        )
    end

    def unclaimed(claim)
        mail(
            to: claim.post.user.email,
            subject: "Your claim on post #{claim.post.number} was refused"
        )
    end
end
