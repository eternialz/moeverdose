class ClaimMailer < ApplicationMailer
    def claimed(claim)
        @claim = claim
        mail(
            to: @claim.post.user.email,
            subject: "Your post (#{@claim.post.number}) is subjet to a takedown notice"
        )
    end

    def unclaimed(claim)
        @claim = claim
        mail(
            to: claim.user.email,
            subject: "Your takedown notice on post #{claim.post.number} was dismissed"
        )
    end
end
